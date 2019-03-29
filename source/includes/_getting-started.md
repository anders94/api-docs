# Getting Started

### Sign Up

If you do not have a Poloniex account yet, use the button below to sign up.

<a href="https://poloniex.com/signup/" class="btn">Sign Up</a>

### Create an API Key

Once you are verified and have an account, you can create an API Key.

Enabling IP address restrictions for API keys is strongly recommended. Withdrawals are disabled by default and must be enabled on a per key basis.

As the name implies, your secret must remain private! If you suspect your key has been compromised, immediately disable that key and generate a new one.

### Authenticate

```shell
# Find the HMAC-SHA512 signature of your POST parameters
# using your secret key. Set the nonce to the current
# milliseconds. (available with date +%s00000)
 echo -n "command=returnBalances&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET
# You will use this signature as a header in your request.
# For example:
 curl -X POST \
     -d "command=returnBalances&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

<aside class="info">
TLS 1.2 or greater is required.
</a></aside>

<aside class="info">
The public endpoint does not require API keys or nonces. So if you are only interested in the public endpoints, skip ahead <a href="/#public-http-api-methods">here.
</a></aside>

Private HTTP endpoints are authenticated using HMAC-SHA512 signed POST request.

Private HTTP endpoints also require a nonce, which must be an integer greater than the previous nonce used. There is no requirement that nonces increase by a specific amount, so the current epoch time in milliseconds is an easy choice. Note that each API key has its own nonce tracking.

### Deposit

Transfer some funds into your account.

- Deposit cryptocurrency you already own
- Tokenize some USDC using a traditional bank account and deposit the USDC into Poloniex. More information available at <a href="https://support.usdc.circle.com/hc/en-us">the USDC Help Center</a>.

### Minimize Latency

If you will be performing high-frequency trading, you may wish to locate your bots as close to our servers as possible. As Poloniex uses Cloudflare for all requests, you can minimize network latency by positioning your client near the Cloudflare gateway in Ashburn, VA, United States. You can identify which Cloudflare gateway your client is accessing by running this command on the same machine as your bot:

```curl -s https://www.cloudflare.com/cdn-cgi/trace```

Cloudflare’s Ashburn data center will return a “colo” field of “IAD”. If you get a different “colo” value, you can look up the location at https://www.cloudflarestatus.com.

