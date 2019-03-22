# Private HTTP API Methods

The private HTTP API allows read / write access to your private account.

<aside class="notice">
Private HTTP URL: `https://poloniex.com/tradingApi`
</aside>

All calls to the trading API are sent via HTTP using POST parameters to https://poloniex.com/tradingApi and must contain the following headers:

* _Key_ - Your API key.
* _Sign_ - The query's POST data signed by your key's "secret" according to the HMAC-SHA512 method.

Additionally, all queries must include a "nonce" POST parameter. The nonce parameter is an integer which must always be greater than the previous nonce used and does not need to increase by one. Using the epoch in milliseconds is an easy choice here but be careful about time synchronization if using the same API key across multiple servers.

All responses from the trading API are in JSON format. In the event of an error, the response will always be of the following format:

`{ "error": "<error message>" }`

There are several methods accepted by the trading API, each of which is specified by the "command" POST parameter:

## returnBalances

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnBalances&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnBalances&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ '1CR': '0.00000000',
  ABY: '0.00000000',
  AC: '0.00000000',
...
  YIN: '0.00000000',
  ZEC: '0.02380926',
  ZRX: '0.00000000' }
```

Returns all of your balances available for trade after having deducted all open orders.

## returnCompleteBalances

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnCompleteBalances&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnCompleteBalances&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ '1CR': 
   { available: '0.00000000',
     onOrders: '0.00000000',
     btcValue: '0.00000000' },
  ABY: 
   { available: '0.00000000',
     onOrders: '0.00000000',
     btcValue: '0.00000000' },
  AC: 
   { available: '0.00000000',
     onOrders: '0.00000000',
     btcValue: '0.00000000' },
...
  YIN: 
   { available: '0.00000000',
     onOrders: '0.00000000',
     btcValue: '0.00000000' },
  ZEC: 
   { available: '0.02380926',
     onOrders: '0.00000000',
     btcValue: '0.00044059' },
  ZRX: 
   { available: '0.00000000',
     onOrders: '0.00000000',
     btcValue: '0.00000000' } }
```

Returns all of your balances, including available balance, balance on orders, and the estimated BTC value of your balance. By default, this call is limited to your exchange account; set the "account" POST parameter to "all" to include your margin and lending accounts.

Field | Description
------|------------
available | Number of tokens not reserved in orders.
onOrders | Number of tokens in open orders.
btcValue | The BTC value of this token's balance.

## returnDepositAddresses

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnDepositAddresses&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnDepositAddresses&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ BCH: '1FhCkdKeMGa621mCpAtFYzeVfUBnHbooLj',
  BTC: '131rdg5Rzn6BFufnnQaHhVa5ZtRU1J2EZR',
...
  XMR: '4JUdGzvrMFDWrUUwY3toJATSeNwjn54LkCnKBPRzDuhzi5vSepHfUckJNxRL2gjkNrSqtCoRUrEDAgRwsQvVCjZbRxGLC7uLNMGQ693YeY',
  ZEC: 't1MHktAs4DMjMWqKiji4czLYD1rGNczGeFV' }
```

Returns all of your deposit addresses.

Some currencies use a common deposit address for everyone on the exchange and designate the account for which this payment is destined by including a payment ID field. In these cases, use `returnCurrencies` to look up the `mainAccount` for the currency to find the deposit address and use the address returned here in the payment ID field. Note: `returnCurrencies` will only include a `mainAccount` property for currencies which require a payment ID.

## generateNewAddress

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=generateNewAddress&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=generateNewAddress&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ success: 1,
  response: '0xa6f0dacc33c7f63e137e0106ed71cc20b4b931af' }
```

Generates a new deposit address for the currency specified by the "currency" POST parameter. Only one address per currency per day may be generated, and a new address may not be generated before the previously-generated one has been used.

Some currencies use a common deposit address for everyone on the exchange and designate the account for which this payment is destined by including a payment ID field. In these cases, use `returnCurrencies` to look up the `mainAccount` for the currency to find the deposit address and use the address returned here in the payment ID field. Note: `returnCurrencies` will only include a `mainAccount` property for currencies which require a payment ID.

### Input Fields

Field | Description
------|------------
currency | The currency to use for the deposit address.

### Output Field

Field | Description
------|------------
success | Denotes the success or failure of the operation.
response | The newly created address.

## returnDepositsWithdrawals

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnDepositsWithdrawals&start=1539954535&end=1540314535&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnDepositsWithdrawals&start=1539954535&end=1540314535&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ deposits: 
   [ { currency: 'BTC',
       address: '131rdg5Rzn6BFufnnQaHhVa5ZtRU1J2EZR',
       amount: '0.06830697',
       confirmations: 1,
       txid: '3a4b9b2404f6e6fb556c3e1d46a9752f5e70a93ac1718605c992b80aacd8bd1d',
       timestamp: 1506005439,
       status: 'COMPLETE' },
     { currency: 'BCH',
       address: '1FhCkdKeMGa621mCpAtFYzeVfUBnHbooLj',
       amount: '10.00000000',
       confirmations: 5,
       txid: 'eb2e0914105b02fbe6e17913d74b4e5950c1ba122eb71afdfc49e2c58b272456',
       timestamp: 1508436102,
       status: 'COMPLETE' },
...
     { currency: 'BTC',
       address: '131rdg5Rzn6BFufnnQaHhVa5ZtRU1J2EZR',
       amount: '1.49998357',
       confirmations: 1,
       txid: 'b05bdec7430a56b5a5ed34af4a31a54859dda9b7c88a5586bc5d6540cdfbfc7a',
       timestamp: 1537304458,
       status: 'COMPLETE' },
     { currency: 'ETH',
       address: '0xb7e033598cb94ef5a35349316d3a2e4f95f308da',
       amount: '29.99825341',
       confirmations: 53,
       txid: '0xf7e7eeb44edcad14c0f90a5fffb1cbb4b80e8f9652124a0838f6906ca939ccd2',
       timestamp: 1537305507,
       status: 'COMPLETE' } ],
  withdrawals: 
   [ { withdrawalNumber: 7397527,
       currency: 'ETC',
       address: '0x26419a62055af459d2cd69bb7392f5100b75e304',
       amount: '13.19951600',
       fee: '0.01000000',
       timestamp: 1506010932,
       status: 'COMPLETE: 0x423346392f82ac16e8c2604f2a604b7b2382d0e9d8030f673821f8de4b5f5a30',
       ipAddress: '1.2.3.4' },
     { withdrawalNumber: 7704882,
       currency: 'ETH',
       address: '0x00c90335F92FfcD26C8c915c79d7aB424454B7c7',
       amount: '0.01318826',
       fee: '0.00500000',
       timestamp: 1507908127,
       status: 'COMPLETE: 0xbd4da74e1a0b81c21d056c6f58a5b306de85d21ddf89992693b812bb117eace4',
       ipAddress: '1.2.3.4' },
...
     { withdrawalNumber: 11967216,
       currency: 'ZRX',
       address: '0x3B2E298b401D1E11cE6ee82b54792CA435CE81eC',
       amount: '1535.58403218',
       fee: '5.00000000',
       timestamp: 1538419390,
       status: 'COMPLETE: 0x52f9e37f29944f20b624df4d7a0ea5a09173e6ea048d49fb05c29585f1d74032',
       ipAddress: '1.2.3.4' },
     { withdrawalNumber: 12017755,
       currency: 'STR',
       address: 'GACNWS3R4FJUMHLDNMFGUQZD33FBRE4IODAPK5G7AVX7S2VEJRT2XXHQ',
       amount: '7281.99772728',
       fee: '0.00001000',
       timestamp: 1539709673,
       status: 'COMPLETE: 2d27ae26fa9c70d6709e27ac94d4ce2fde19b3986926e9f3bfcf3e2d68354ec5',
       ipAddress: '1.2.3.4' } ] }
```

Returns your deposit and withdrawal history within a range window, specified by the "start" and "end" POST parameters, both of which should be given as UNIX timestamps.

### Input Fields

Field | Description
------|------------
start | The start date of the range window in UNIX timestamp format.
end | The end date of the range window in UNIX timestamp format.

### Deposit Output Fields

Field | Description
------|------------
currency | The currency of this deposit.
address | The address to which this deposit was sent.
amount | The total value of the deposit. (network fees will not be included in this)
confirmations | The total number of confirmations for this deposit.
txid | The blockchain transaction ID of this deposit.
timestamp | The timestamp in UNIX timestamp format of when this deposit was first noticed.
status | The current status of this deposit. (either `PENDING` or `COMPLETE`)

### Withdrawal Output Fields

Field | Description
------|------------
withdrawalNumber | The unique Poloniex specific withdrawal ID for this withdrawal.
currency | The currency of this withdrawal.
address | The address to which the withdrawal was made.
amount | The total amount withdrawn including the fee.
fee | The fee paid to the exchange for this withdrawal.
timestamp | The Unix timestamp of the withdrawal.
status | The status of the withdrawal (one of `PENDING`, `AWAITING APPROVAL`, `COMPLETE` or `COMPLETE ERROR`) and optionally the transaction ID of the withdrawal.
ipAddress | The IP address which initiated the withdrawal request.

## returnOpenOrders

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnOpenOrders&currencyPair=BTC_ETH&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnOpenOrders&currencyPair=BTC_ETH&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output for a single market:

```json
[ { orderNumber: '514514894224',
    type: 'buy',
    rate: '0.00001000',
    startingAmount: '100.00000000',
    amount: '100.00000000',
    total: '0.00100000',
    date: '2018-10-23 17:38:53',
    margin: 0 },
  { orderNumber: '514515104014',
    type: 'buy',
    rate: '0.00002000',
    startingAmount: '100.00000000',
    amount: '100.00000000',
    total: '0.00200000',
    date: '2018-10-23 17:39:46',
    margin: 0 },
...
  { orderNumber: '514515150967',
    type: 'buy',
    rate: '0.00003000',
    startingAmount: '100.00000000',
    amount: '100.00000000',
    total: '0.00300000',
    date: '2018-10-23 17:39:55',
    margin: 0 } ]
```

> Example output for all markets:

```json
{ BTC_ARDR: [],
  BTC_BAT: [],
  BTC_BCH: [],
...
  BTC_ETH: 
   [ { orderNumber: '514515459658',
       type: 'buy',
       rate: '0.00001000',
       startingAmount: '100.00000000',
       amount: '100.00000000',
       total: '0.00100000',
       date: '2018-10-23 17:41:15',
       margin: 0 },
...
     { orderNumber: '514515389728',
       type: 'buy',
       rate: '0.00003000',
       startingAmount: '100.00000000',
       amount: '100.00000000',
       total: '0.00300000',
       date: '2018-10-23 17:40:55',
       margin: 0 } ],
  BTC_FCT: [],
...
  BTC_SC: 
   [ { orderNumber: '26422960740',
       type: 'buy',
       rate: '0.00000001',
       startingAmount: '100000.00000000',
       amount: '100000.00000000',
       total: '0.00100000',
       date: '2018-10-23 17:41:49',
       margin: 0 },
     { orderNumber: '26422963737',
       type: 'buy',
       rate: '0.00000002',
       startingAmount: '100000.00000000',
       amount: '100000.00000000',
       total: '0.00200000',
       date: '2018-10-23 17:42:00',
       margin: 0 } ],
  BTC_SNT: [],
...
  XMR_NXT: [],
  XMR_ZEC: [] }
```

Returns your open orders for a given market, specified by the "currencyPair" POST parameter, e.g. "BTC_ETH". Set "currencyPair" to "all" to return open orders for all markets.

### Input Fields

Field | Description
------|------------
currencyPair | The major and minor currency that define this market. (or 'all' for all markets)

### Output Fields

Field | Description
------|------------
orderNumber | The number uniquely identifying this order.
type | Denotes this order as a 'buy' or 'sell'.
rate | The price per unit in base units.
startingAmount | The size of the original order.
amount | The amount left to fill in this order.
total | The total cost of this order in base units.
date | The UTC date of order creation.
margin | Denotes this as a margin order (1) or not. (0)

## returnTradeHistory (private)

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnTradeHistory&currencyPair=BTC_ETH&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnTradeHistory&currencyPair=BTC_ETH&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output for a single market:

```json
[ { globalTradeID: 394700861,
    tradeID: 45210354,
    date: '2018-10-23 18:01:58',
    type: 'buy',
    rate: '0.03117266',
    amount: '0.00000652',
    total: '0.00000020' },
  { globalTradeID: 394700815,
    tradeID: 45210353,
    date: '2018-10-23 18:01:08',
    type: 'buy',
    rate: '0.03116000',
    amount: '5.93292717',
    total: '0.18487001' },
...
  { globalTradeID: 394699047,
    tradeID: 45210256,
    date: '2018-10-23 17:30:32',
    type: 'sell',
    rate: '0.03114533',
    amount: '0.01934000',
    total: '0.00060235' },
  { globalTradeID: 394698946,
    tradeID: 45210255,
    date: '2018-10-23 17:28:55',
    type: 'sell',
    rate: '0.03114126',
    amount: '0.00018753',
    total: '0.00000583' } ]
```

> Example output for all markets:

```json
{ BTC_BCH: 
   [ { globalTradeID: 394131412,
       tradeID: '5455033',
       date: '2018-10-16 18:05:17',
       rate: '0.06935244',
       amount: '1.40308443',
       total: '0.09730732',
       fee: '0.00100000',
       orderNumber: '104768235081',
       type: 'sell',
       category: 'exchange' },
...
     { globalTradeID: 394126818,
       tradeID: '5455007',
       date: '2018-10-16 16:55:34',
       rate: '0.06935244',
       amount: '0.00155709',
       total: '0.00010798',
       fee: '0.00200000',
       orderNumber: '104768179137',
       type: 'sell',
       category: 'exchange' } ],
  BTC_STR: 
   [ { globalTradeID: 394127362,
       tradeID: '13536351',
       date: '2018-10-16 17:03:43',
       rate: '0.00003432',
       amount: '3696.05342780',
       total: '0.12684855',
       fee: '0.00200000',
       orderNumber: '96238912841',
       type: 'buy',
       category: 'exchange' },
...
     { globalTradeID: 394127361,
       tradeID: '13536350',
       date: '2018-10-16 17:03:43',
       rate: '0.00003432',
       amount: '3600.53748129',
       total: '0.12357044',
       fee: '0.00200000',
       orderNumber: '96238912841',
       type: 'buy',
       category: 'exchange' } ] }
```

Returns your trade history for a given market, specified by the "currencyPair" POST parameter. You may specify "all" as the currencyPair to receive your trade history for all markets. You may optionally specify a range via "start" and/or "end" POST parameters, given in UNIX timestamp format; if you do not specify a range, it will be limited to one day. You may optionally limit the number of entries returned using the "limit" parameter, up to a maximum of 10,000. If the "limit" parameter is not specified, no more than 500 entries will be returned.

### Input Fields

Field | Description
------|------------
currencyPair | The major and minor currency that define this market. (or 'all' for all markets)

### Output Fields

Field | Description
------|------------
globalTradeID | The globally unique identifier of this trade.
tradeID | The identifier of this trade unique only within this trading pair.
date | The UTC date at which this trade executed.
rate | The rate at which this trade executed.
amount | The amount transacted in this trade.
total | The total cost in base units of this trade.
fee | The fee paid for this trade.
orderNumber | The order number to which this trade is associated.
type | Denotes a 'buy' or a 'sell' execution.
category | Denotes if this was a standard or margin exchange.

## returnOrderTrades

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnOrderTrades&orderNumber=96238912841&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnOrderTrades&orderNumber=9623891284&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
[ { globalTradeID: 394127362,
    tradeID: 13536351,
    currencyPair: 'BTC_STR',
    type: 'buy',
    rate: '0.00003432',
    amount: '3696.05342780',
    total: '0.12684855',
    fee: '0.00200000',
    date: '2018-10-16 17:03:43' },
  { globalTradeID: 394127361,
    tradeID: 13536350,
    currencyPair: 'BTC_STR',
    type: 'buy',
    rate: '0.00003432',
    amount: '3600.53748129',
    total: '0.12357044',
    fee: '0.00200000',
    date: '2018-10-16 17:03:43' } ]
```

Returns all trades involving a given order, specified by the "orderNumber" POST parameter. If no trades for the order have occurred or you specify an order that does not belong to you, you will receive an error. See the documentation here for how to use the information from returnOrderTrades and returnOrderStatus to determine various status information about an order.

### Input Fields

Field | Description
------|------------
orderNumber | The order number whose trades you wish to query.

### Output Fields

Field | Description
------|------------
globalTradeID | The globally unique identifier of this trade.
tradeID | The identifier of this trade unique only within this trading pair.
currencyPair | The major and minor currencies which define this market.
type | Denotes a 'buy' or a 'sell' execution.
rate | The rate at which this trade executed.
amount | The amount transacted in this trade.
total | The total cost in base units of this trade.
fee | The fee paid for this trade.
date | The UTC date at which this trade executed.

## returnOrderStatus

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnOrderStatus&orderNumber=96238912841&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnOrderStatus&orderNumber=9623891284&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ result: 
   { '6071071': 
      { status: 'Open',
        rate: '0.40000000',
        amount: '1.00000000',
        currencyPair: 'BTC_ETH',
        date: '2018-10-17 17:04:50',
        total: '0.40000000',
        type: 'buy',
        startingAmount: '1.00000' } },
  success: 1 }
```

Returns the status of a given order, specified by the "orderNumber" POST parameter. If the specified orderNumber is not open, or it is not yours, you will receive an error.

Note that returnOrderStatus, in concert with returnOrderTrades, can be used to determine various status information about an order:

* If returnOrderStatus returns status: "Open", the order is fully open.
* If returnOrderStatus returns status: "Partially filled", the order is partially filled, and returnOrderTrades may be used to find the list of those fills.
* If returnOrderStatus returns an error and returnOrderTrades returns an error, then the order was cancelled before it was filled.
* If returnOrderStatus returns an error and returnOrderTrades returns a list of trades, then the order had fills and is no longer open (due to being completely filled, or partially filled and then cancelled).

### Input Fields

Field | Description
------|------------
orderNumber | The identifier of the order to return.

### Output Field

Field | Description
------|------------
status | Designates this order's fill state.
rate | The rate in base units of this order.
amount | The amount of tokens remaining unfilled in this order.
currencyPair | The market to which this order belongs.
date | The UTC date this order was created.
total | The total value of this order.
type | Designates a buy or a sell order.
startingAmount | The original order's amount.

## buy

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=buy&currencyPair=BTC_ETH&rate=0.01&amount=1&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=buy&currencyPair=BTC_ETH&rate=0.01&amount=1&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ orderNumber: '514845991795',
  resultingTrades: 
   [ { amount: '3.0',
       date: '2018-10-25 23:03:21',
       rate: '0.0002',
       total: '0.0006',
       tradeID: '251834',
       type: 'buy' } ] }
```

Places a limit buy order in a given market. Required POST parameters are "currencyPair", "rate", and "amount". If successful, the method will return the order number.

You may optionally set "fillOrKill", "immediateOrCancel", "postOnly" to 1. A fill-or-kill order will either fill in its entirety or be completely aborted. An immediate-or-cancel order can be partially or completely filled, but any portion of the order that cannot be filled immediately will be canceled rather than left on the order book. A post-only order will only be placed if no portion of it fills immediately; this guarantees you will never pay the taker fee on any part of the order that fills.

### Input Fields

Field | Description
------|------------
currencyPair | The major and minor currency defining the market where this buy order should be placed.
rate | The rate to purchase one major unit for this trade.
amount | The total amount of minor units offered in this buy order.
fillOrKill | (optional) Set to "1" if this order should either fill in its entirety or be completely aborted.
immediateOrCancel | (optional) Set to "1" if this order can be partially or completely filled, but any portion of the order that cannot be filled immediately will be canceled.
postOnly | (optional) Set to "1" if you want this buy order to only be placed if no portion of it fills immediately.

### Output Fields

Field | Description
------|------------
orderNumber | The identification number of the newly created order.
resultingTrades | An array of the trades that were executed, if any, on order placement.
amount | The amount of tokens remaining unfilled in this order.
date | The UTC date this order was created.
rate | The rate in base units of this order.
total | The total value of this order.
tradeID | The identifier for this trade.
type | Designates a buy or a sell order. (always 'buy' in this case)

## sell

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=sell&currencyPair=BTC_ETH&rate=10.0&amount=1&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=sell&currencyPair=BTC_ETH&rate=10.0&amount=1&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ orderNumber: '514845991926',
  resultingTrades: 
   [ { amount: '1.0',
       date: '2018-10-25 23:03:21',
       rate: '10.0',
       total: '10.0',
       tradeID: '251869',
       type: 'sell' } ] }
```

Places a sell order in a given market. Required POST parameters are "currencyPair", "rate", and "amount". If successful, the method will return the order number.

You may optionally set "fillOrKill", "immediateOrCancel", "postOnly" to 1. A fill-or-kill order will either fill in its entirety or be completely aborted. An immediate-or-cancel order can be partially or completely filled, but any portion of the order that cannot be filled immediately will be canceled rather than left on the order book. A post-only order will only be placed if no portion of it fills immediately; this guarantees you will never pay the taker fee on any part of the order that fills.

### Input Fields

Field | Description
------|------------
currencyPair | The major and minor currency defining the market where this sell order should be placed.
rate | The rate to purchase one major unit for this trade.
amount | The total amount of minor units offered in this sell order.
fillOrKill | (optional) Set to "1" if this order should either fill in its entirety or be completely aborted.
immediateOrCancel | (optional) Set to "1" if this order can be partially or completely filled, but any portion of the order that cannot be filled immediately will be canceled.
postOnly | (optional) Set to "1" if you want this sell order to only be placed if no portion of it fills immediately.

### Output Fields

Field | Description
------|------------
orderNumber | The identification number of the newly created order.
resultingTrades | An array of the trades that were executed, if any, on order placement.
amount | The amount of tokens remaining unfilled in this order.
date | The UTC date this order was created.
rate | The rate in base units of this order.
total | The total value of this order.
tradeID | The identifier for this trade.
type | Designates a buy or a sell order. (always 'sell' in this case)

## cancelOrder

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=cancelOrder&orderNumber=514845991795&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=cancelOrder&orderNumber=514845991795&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ success: 1,
  amount: '50.00000000',
  message: 'Order #514845991795 canceled.' }
```

Cancels an order you have placed in a given market. Required POST parameter are "currencyPair" and "orderNumber". If successful, the method will return a success of 1.

### Input Fields

Field | Description
------|------------
orderNumber | The identity number of the order to be canceled.

### Output Fields

Field | Description
------|------------
success | A boolean indication of the success or failure of this operation.
amount | The remaning unfilled amount that was canceled in this operation.
message | A human readable description of the result of the action.

## moveOrder

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=moveOrder&orderNumber=514851026755&rate=0.00015&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=moveOrder&orderNumber=514851026755&rate=0.00015&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ success: 1,
  orderNumber: '514851232549',
  resultingTrades: { BTC_ETH: [] } }
```

Cancels an order and places a new one of the same type in a single atomic transaction, meaning either both operations will succeed or both will fail. Required POST parameters are "orderNumber" and "rate"; you may optionally specify "amount" if you wish to change the amount of the new order. "postOnly" or "immediateOrCancel" may be specified for exchange orders, but will have no effect on margin orders.

### Input Fields

Field | Description
------|------------
orderNumber | The identity number of the order to be canceled.

### Output Fields

Field | Description
------|------------
success | A boolean indication of the success or failure of this operation.
amount | The remaning unfilled amount that was canceled in this operation.
message | A human readable description of the result of the action.

## withdraw

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=withdraw&currency=ETH&amount=2&address=0x84a90e21d9d02e30ddcea56d618aa75ba90331ff&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=withdraw&currency=ETH&amount=2&address=0x84a90e21d9d02e30ddcea56d618aa75ba90331ff&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ response: 'Withdrew 2.0 ETH.' }
```

Immediately places a withdrawal for a given currency, with no email confirmation. In order to use this method, withdrawal privilege must be enabled for your API key. Required POST parameters are "currency", "amount", and "address". For withdrawals which support payment IDs, (such as XMR) you may optionally specify "paymentId".

## returnFeeInfo

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnFeeInfo&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnFeeInfo&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ makerFee: '0.00100000',
  takerFee: '0.00200000',
  thirtyDayVolume: '106.08463302',
  nextTier: 500000 }
```

If you are enrolled in the maker-taker fee schedule, returns your current trading fees and trailing 30-day volume in BTC. This information is updated once every 24 hours.

### Output Fields

Field | Description
------|------------
makerFee | The fee you pay when your order executes after having not matched when it was initially placed.
takerFee | The fee you pay when your order matches an existing offer.
thirtyDayVolume | The total trading volume for your account.
nextTier | The volume necessary to reach the next fee tier.

## returnAvailableAccountBalances

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnAvailableAccountBalances&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnAvailableAccountBalances&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
 { exchange: 
   { BTC: '0.10000000',
     EOS: '5.18012931',
     ETC: '3.39980734',
     SC: '120.00000000',
     USDC: '23.79999938',
     ZEC: '0.02380926' },
  margin: 
   { BTC: '0.50000000' },
  lending: 
   { BTC: '0.14804126',
     ETH: '2.69148073',
     LTC: '1.75862721',
     XMR: '5.25780982' } }
```

Returns your balances sorted by account. You may optionally specify the "account" POST parameter if you wish to fetch only the balances of one account. Please note that balances in your margin account may not be accessible if you have any open margin positions or orders.

### Output Fields

Field | Description
------|------------
exchange | The assets available to trade in your exchange account.
margin | The assets available to trade in your margin account.
lending | The assets available to trade in your lending account.

## returnTradableBalances

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnTradableBalances&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnTradableBalances&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ BTC_BTS: { BTC: '1.25000000', BTS: '81930.25407233' },
  BTC_CLAM: { BTC: '1.25000000', CLAM: '4266.69596390' },
  BTC_DASH: { BTC: '1.25000000', DASH: '51.93926104' },
  BTC_DOGE: { BTC: '1.25000000', DOGE: '2155172.41379310' },
  BTC_LTC: { BTC: '1.25000000', LTC: '154.46087826' },
  BTC_MAID: { BTC: '1.25000000', MAID: '38236.28007965' },
  BTC_STR: { BTC: '1.25000000', STR: '34014.47559076' },
  BTC_XMR: { BTC: '1.25000000', XMR: '76.27023112' },
  BTC_XRP: { BTC: '1.25000000', XRP: '17385.96302541' },
  BTC_ETH: { BTC: '1.25000000', ETH: '39.96803109' },
  BTC_FCT: { BTC: '1.25000000', FCT: '1720.79314097' } }
```

Returns your current tradable balances for each currency in each market for which margin trading is enabled. Please note that these balances may vary continually with market conditions.

## transferBalance

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=transferBalance&currency=BTC&amount=0.5&fromAccount=lending&toAccount=exchange&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=transferBalance&currency=BTC&amount=0.5&fromAccount=lending&toAccount=exchange&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ success: 1,
  message: 'Transferred 0.50000000 BTC from lending to exchange account.' }
```

Transfers funds from one account to another (e.g. from your exchange account to your margin account). Required POST parameters are "currency", "amount", "fromAccount", and "toAccount".

### Input Fields

Field | Description
------|------------
currency | The currency to transfer.
amount | The amount of assets to transfer in this request.
fromAccount | The account from which this value should be moved.
toAccount | The account to which this value should be moved.

### Output Fields

Field | Description
------|------------
success | The success or failure message for this transfer.
message | A human readable message summarizing this transfer.

## returnMarginAccountSummary

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnMarginAccountSummary&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnMarginAccountSummary&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ totalValue: '0.09999999',
  pl: '0.00000000',
  lendingFees: '0.00000000',
  netValue: '0.09999999',
  totalBorrowedValue: '0.02534580',
  currentMargin: '3.94542646' }
```

Returns a summary of your entire margin account. This is the same information you will find in the Margin Account section of the (Margin Trading page)[https://poloniex.com/support/aboutMarginTrading/], under the Markets list.

### Output Fields

Field | Description
------|------------
totalValue | Total margin value	in BTC.
pl | Unrealized profit and loss in BTC.
lendingFees | Unrealized lending fees in BTC.
netValue | Net value in BTC.
totalBorrowedValue | Total borrowed value in BTC.
currentMargin | The current margin ratio.

## marginBuy

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=marginBuy&currencyPair=BTC_ETH&rate=0.002&amount=20&&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=marginBuy&currencyPair=BTC_ETH&rate=0.002&amount=20&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ orderNumber: '515007818806',
  resultingTrades: [],
  message: 'Margin order placed.' }
```

Places a margin buy order in a given market. Required POST parameters are "currencyPair", "rate", and "amount". You may optionally specify a maximum lending rate using the "lendingRate" parameter. (the default "lendingRate" value is 0.02) Note that "rate" * "amount" must be > 0.02 when creating or expanding a market. If successful, the method will return the order number and any trades immediately resulting from your order.

### Input Fields

Field | Description
------|------------
currencyPair | The major and minor currency that define this market.
rate | The rate to purchase one major unit for this trade.
lendingRate | The interest rate you are willing to accept in percentage per day. (default is 0.02)
amount | The amount of currency to buy in minor currency units.

### Output Fields

Field | Description
------|------------
orderNumber | The newly created order number.
resultingTrades | An array of trades immediately filled by this offer, if any.
message | A human-readable message summarizing the activity.

## marginSell

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=marginSell&currencyPair=BTC_ETH&rate=0.002&amount=20&&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=marginSell&currencyPair=BTC_ETH&rate=0.002&amount=20&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ orderNumber: '515007818812',
  resultingTrades: [],
  message: 'Margin order placed.' }
```

Places a margin sell order in a given market. Required POST parameters are "currencyPair", "rate", and "amount". You may optionally specify a maximum lending rate using the "lendingRate" parameter. (the default "lendingRate" value is 0.02) Note that "rate" * "amount" must be > 0.02 when creating or expanding a market. If successful, the method will return the order number and any trades immediately resulting from your order.

### Input Fields

Field | Description
------|------------
currencyPair | The major and minor currency that define this market.
rate | The rate to purchase one major unit for this trade.
lendingRate | The interest rate you are willing to accept in percentage per day. (default is 0.02)
amount | The amount of currency to sell in minor currency units.

### Output Fields

Field | Description
------|------------
orderNumber | The newly created order number.
resultingTrades | An array of trades immediately filled by this offer, if any.
message | A human-readable message summarizing the activity.

## getMarginPosition

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=getMarginPosition&currencyPair=BTC_ETH&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=getMarginPosition&currencyPair=BTC_ETH&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ amount: '40.94717831',
  total: '-0.09671314',
  basePrice: '0.00236190',
  liquidationPrice: -1,
  pl: '-0.00058655',
  lendingFees: '-0.00000038',
  type: 'long' }
```

Returns information about your margin position in a given market, specified by the "currencyPair" POST parameter. You may set "currencyPair" to "all" if you wish to fetch all of your margin positions at once. If you have no margin position in the specified market, "type" will be set to "none". "liquidationPrice" is an estimate, and does not necessarily represent the price at which an actual forced liquidation will occur. If you have no liquidation price, the value will be -1.

### Input Fields

Field | Description
------|------------
currencyPair | The major and minor currency that define this market.

### Output Fields

Field | Description
------|------------
amount | The net amount of the market's currency you have bought or sold. If your position is short, this value will be negative.
total | The total amount of the currency in your position.
basePrice | The approximate price at which you would need to close your position in order to break even.
liquidationPrice | The estimated highest bid (if your position is long) or lowest ask (if it is short) at which a forced liquidation will occur.
pl | Estimated profit or loss you would incur if your position were closed. Includes lending fees already paid.
lendingFees | The estimated value of outstanding fees on currently-open loans.
type | Denotes the overall position in this market as either "long" (buy heavy) or "short". (sell heavy)

## closeMarginPosition

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=closeMarginPosition&currencyPair=BTC_ETH&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=closeMarginPosition&currencyPair=BTC_ETH&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output for a market with an open position:

```json
{ success: 1,
  message: 'Successfully closed margin position.',
  resultingTrades:
   { BTC_XMR:
      [ { amount: '7.09215901',
          date: '2015-05-10 22:38:49',
          rate: '0.00235337',
          total: '0.01669047',
          tradeID: '1213346',
          type: 'sell' },
        { amount: '24.00289920',
          date: '2015-05-10 22:38:49',
          rate: '0.00235321',
          total: '0.05648386',
          tradeID: '1213347',
          type: 'sell' } ] } }
```

> Example output for a market with no open position:

```json
{ success: 1,
  message: 'You do not have an open position in this market.',
  resultingTrades: [] }
```

Closes your margin position in a given market (specified by the "currencyPair" POST parameter) using a market order. This call will also return success if you do not have an open position in the specified market.

### Input Fields

Field | Description
------|------------
currencyPair | The major and minor currency that define this market.

### Output Fields

Field | Description
------|------------
success | Denotes whether a success (1) or a failure (0) of this operation.
message | A human-readable message summarizing the activity.
resultingTrades | An array of any trades that have executed as a result of closing this position.

## createLoanOffer

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=createLoanOffer&currency=BTC&amount=0.1&duration=2&autoRenew=0&lendingRate=0.015&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=createLoanOffer&currency=BTC&amount=0.1&duration=2&autoRenew=0&lendingRate=0.015&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output for a market with an open position:

```json
{ success: 1,
  message: 'Loan order placed.',
  orderID: 1002013188 }
```

Creates a loan offer for a given currency. Required POST parameters are "currency", "amount", "duration", "autoRenew" (0 or 1), and "lendingRate".

### Input Fields

Field | Description
------|------------
currency | Denotes the currency for this loan offer.
amount | The total amount of currency offered.
duration | The maximum duration of this loan in days. (from 2 to 60, inclusive)
autoRenew | Denotes if this offer should be reinstated with the same settings after having been taken.

### Output Fields

Field | Description
------|------------
success | Denotes whether a success (1) or a failure (0) of this operation.
message | A human-readable message summarizing the activity.
orderID | The identification number of the newly created loan offer.

## cancelLoanOffer

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=cancelLoanOffer&orderNumber=1002013188&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=cancelLoanOffer&orderNumber=1002013188&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output for a market with an open position:

```json
{ success: 1,
  message: 'Loan offer canceled.',
  amount: '0.10000000' }
```

Cancels a loan offer specified by the "orderNumber" POST parameter.

### Input Fields

Field | Description
------|------------
orderNumber | The identification number of the offer to be canceled.

### Output Fields

Field | Description
------|------------
success | Denotes whether a success (1) or a failure (0) of this operation.
message | A human-readable message summarizing the activity.
amount | The amount of the offer that was canceled.

## returnOpenLoanOffers

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnOpenLoanOffers&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnOpenLoanOffers&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output for a market with an open position:

```json
{ BTC:
   [ { id: 1002015083,
       rate: '0.01500000',
       amount: '0.10000000',
       duration: 2,
       autoRenew: 0,
       date: '2018-10-26 20:26:46' } ] }
```

Returns your open loan offers for each currency.

### Output Fields

Field | Description
------|------------
id | The identification number of this offer.
rate | The rate in percent per day to charge for this loan.
amount | The total amount offered for this loan.
duration | The maximum number of days offered for this loan.
autoRenew | Denotes if this offer will be reinstated with the same settings after having been taken.
date | The UTC date at which this loan offer was created.

## returnActiveLoans

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnActiveLoans&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnActiveLoans&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ provided:
   [ { id: 75073,
       currency: 'LTC',
       rate: '0.00020000',
       amount: '0.72234880',
       range: 2,
       autoRenew: 0,
       date: '2018-05-10 23:45:05',
       fees: '0.00006000' },
     { id: 74961,
       currency: 'LTC',
       rate: '0.00002000',
       amount: '4.43860711',
       range: 2,
       autoRenew: 0,
       date: '2018-05-10 23:45:05',
       fees: '0.00006000' } ],
  used:
   [ { id: 75238,
       currency: 'BTC',
       rate: '0.00020000',
       amount: '0.04843834',
       range: 2,
       date: '2018-05-10 23:51:12',
       fees: '-0.00000001' } ] }
```

Returns your active loans for each currency.

Output Field | Description
-------------|------------
provided | An array of the loans currently provided. (see below for subfield descriptions)
used | An array of the loans currently being used. (see below for subfield descriptions)

Subfield | Description
---------|------------
id | The identifier number of the loan.
currency | The currency of the loan.
rate | The rate in percentage per day.
amount | The size of this loan.
range | The duration of the loan in number of days.
autoRenew | Specifies if the loan will be automatically renewed on close.
date | The UTC date of the start of the loan.
fees | The fees paid for this loan so far.

## returnLendingHistory

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=returnLendingHistory&start=1483228800&end=1483315200&limit=100&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=returnLendingHistory&start=1483228800&end=1483315200&limit=100&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
[ { id: 246300115,
    currency: 'BTC',
    rate: '0.00013890',
    amount: '0.33714830',
    duration: '0.00090000',
    interest: '0.00000005',
    fee: '0.00000000',
    earned: '0.00000005',
    open: '2017-01-01 23:41:37',
    close: '2017-01-01 23:42:51' },
  { id: 246294775,
    currency: 'BTC',
    rate: '0.00013890',
    amount: '0.03764586',
    duration: '0.00150000',
    interest: '0.00000001',
    fee: '0.00000000',
    earned: '0.00000001',
    open: '2017-01-01 23:36:32',
    close: '2017-01-01 23:38:45' },
...
  { id: 245670087,
    currency: 'BTC',
    rate: '0.00014000',
    amount: '0.10038365',
    duration: '0.00010000',
    interest: '0.00000001',
    fee: '0.00000000',
    earned: '0.00000001',
    open: '2017-01-01 03:18:25',
    close: '2017-01-01 03:18:32' },
  { id: 245645491,
    currency: 'XMR',
    rate: '0.00002191',
    amount: '0.00006579',
    duration: '0.00560000',
    interest: '0.00000001',
    fee: '0.00000000',
    earned: '0.00000001',
    open: '2017-01-01 02:17:09',
    close: '2017-01-01 02:25:10' } ]
```

Returns your lending history within a time range specified by the "start" and "end" POST parameters as UNIX timestamps. "limit" may also be specified to limit the number of rows returned.

Input Field | Description
------------|------------
start | The date in Unix timestamp format of the start of the window.
end | The date in Unix timestamp format of the end of the window.

Output Field | Description
-------------|------------
id | The loan identifier number.
currency | The currency of the loan.
rate | The loan's rate in percentage points per day.
amount | The total amount loaned.
duration | The duration in days of the loan.
interest | The interest earned in the loan's currency.
fee | The fee paid in the loan's currency.
earned | The earnings in the loan's currency after subtracting the fee.
open | The UTC date the loan started. (when the loan offer was taken)
close | The UTC date the loan completed. (when the loan was closed)

## toggleAutoRenew

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "command=toggleAutoRenew&orderNumber=1002013188&nonce=154264078495300" | \
openssl sha512 -hmac $API_SECRET

curl -X POST \
     -d "command=toggleAutoRenew&orderNumber=1002013188&nonce=154264078495300" \
     -H "Key: 7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J" \
     -H "Sign: 2a7849ecf...ae71161c8e9a364e21d9de9" \
     https://poloniex.com/tradingApi
```

> Example output:

```json
{ success: 1, message: 0 }
```

Toggles the autoRenew setting on an active loan, specified by the "orderNumber" POST parameter. If successful, "message" will indicate the new autoRenew setting.

Input Field | Description
------------|------------
orderNumber | The identifier of the order you want to toggle.

Output Field | Description
-------------|------------
success | A "1" indicates a successful toggle.
message | On success, the new value of the auto renew flag.
