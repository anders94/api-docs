#!/bin/bash
set -ex

# builds the site and release to an s3 bucket, invalidate cloudfront distribution

# build site
gem install bundler -v 1.16.6
bundle _1.16.6_ install
bundle _1.16.6_ exec middleman build --clean

# sync site to s3 bucket
cd build
aws s3 sync . s3://${BUCKET}

# invalidate site and wait until complete
aws cloudfront wait distribution-deployed --id "$DISTID"
INVALIDATION=$(aws cloudfront create-invalidation --distribution-id "$DISTID" --paths "/*")
INVALIDATIONID=$(echo $INVALIDATION | jq .Invalidation.Id | tr -d '"')
if [ "${INVALIDATIONID}" = "" ]
then
   echo "Error: unable to find Invalidation Id"
   echo $INVALIDATION
   exit 1
fi
aws cloudfront wait invalidation-completed --distribution-id "$DISTID" --id "$INVALIDATIONID"

