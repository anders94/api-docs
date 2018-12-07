# Introduction

> Setup

```shell
# make sure you have curl installed
```

Poloniex provides both HTTP and websocket APIs for interacting with the exchange. Both allow read access to public market data and private read access to your account. Private write access to your account is available via the private HTTP API.

The public HTTP endpoint is accessed via GET requests while the private endpoint is accessed via HMAC-SHA512 signed POST requests using [API keys](https://poloniex.com/apiKeys). Both types of HTTP endpoints return results in JSON format.

The websocket API allows push notifications about the public order books, lend books and your private account. Similarly to the HTTP API, it requires HMAC-SHA512 signed requests using [API keys](https://poloniex.com/apiKeys) for requests related to your private account.
