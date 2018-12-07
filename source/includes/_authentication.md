# Authentication

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

To use private API services such as the account notifications channel or the trading APIs, you will need a valid API key.

<aside class="success">
The public endpoint does not require API keys or nonces.
</aside>

Private HTTP endpoints also require a nonce, which must be an integer greater than the previous nonce used. There is no requirement that nonces increase by a specific amount, so the current epoch time in milliseconds is an easy choice. Note that each API key has its own nonce tracking.

### Creating an API Key

* If you don't already have one, [create a Poloniex account](https://poloniex.com/signup/).
* Transfer some funds into your account
  * Deposit cryptocurrency you already own
  * [Tokenize some USDC](https://usdc.circle.com/start) using a traditional bank account and deposit the USDC into Poloniex. More information available at the [USDC Help Center](https://support.usdc.circle.com/hc/en-us/categories/360000088383-About-Circle-USDC). 
* [Create an API key](https://poloniex.com/apiKeys)
* Enable API access
  * Create a new API Key
    * Optionally enable or disable trading and withdrawals
    * Select IP address restrictions

Each API key has its own nonce tracking and may be configured with its own unique settings. API access is limited to 6 calls per second for each API key.

Enabling IP address restrictions for API keys is highly recommended. Withdrawals are disabled by default but may be enabled on a per key basis.

<aside class="warning">
As the name implies, your secret key must remain private! If you suspect your key has been compromised, immediately disable that key and generate a new one.
</aside>
