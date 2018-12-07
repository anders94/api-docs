# Public HTTP API Methods

The public HTTP API allows read access to public market data.

<aside class="notice">
Public HTTP URL: `https://poloniex.com/public`
</aside>

There are seven public methods, all of which take HTTP GET requests and return output in JSON format. No authentication is necessary but you must not excessivly use any API endpoint.

## returnTicker

```shell
curl "https://poloniex.com/public?command=returnTicker"
```

> Example output:

```json
...
{ BTC_BCN:
   { id: 7,
     last: '0.00000024',
     lowestAsk: '0.00000025',
     highestBid: '0.00000024',
     percentChange: '0.04347826',
     baseVolume: '58.19056621',
     quoteVolume: '245399098.35236773',
     isFrozen: '0',
     high24hr: '0.00000025',
     low24hr: '0.00000022' },
  USDC_BTC:
   { id: 224,
     last: '6437.65329245',
     lowestAsk: '6436.73575054',
     highestBid: '6425.68259132',
     percentChange: '0.00744080',
     baseVolume: '1193053.18913982',
     quoteVolume: '185.43611063',
     isFrozen: '0',
     high24hr: '6499.09114231',
     low24hr: '6370.00000000' },
...
```

Retrieves summary information for each currency pair listed on the exchange. Fields include:

Field | Description
------|------------
id | Id of the [currency pair](#currency-pair-ids).
last | Execution price for the most recent trade for this pair.
lowestAsk | Lowest current purchase price for this asset.
highestBid | Highest current sale price for this asset.
percentChange | Price change percentage.
baseVolume | Base units traded in the last 24 hours.
quoteVolume | Quoted units traded in the last 24 hours.
isFrozen | Indicates if this market is currently trading or not.
high24hr | The highest execution price for this pair within the last 24 hours.
low24hr | The lowest execution price for this pair within the last 24 hours.

## return24Volume

```shell
curl "https://poloniex.com/public?command=return24hVolume"
```

> Example output:

```json
{ BTC_LTC: { BTC: '38.13504038', LTC: '4662.34229096' },
  BTC_MAID: { BTC: '10.38010322', MAID: '359919.71515255' },
...
  USDC_BTC: { USDC: '481389.13175764', BTC: '74.73988488' },
  USDC_ETH: { USDC: '72302.27016210', ETH: '357.72884034' },
  totalBTC: '2340.96441558',
  totalETH: '2771.63218462',
  totalUSDC: '681255.56961992',
  totalXMR: '267.83601213' }
```

Returns the 24-hour volume for all markets as well as totals for primary currencies.

Primary currencies include `BTC`, `ETH`, `USDT`, `USDC` and `XMR` and show the total amount of those tokens that have traded within the last 24 hours.

## returnOrderBook

```shell
curl "https://poloniex.com/public?command=returnOrderBook&currencyPair=BTC_ETH&depth=10"
```

> Example output for a selected market:

```json
{ asks: 
   [ [ '0.03142500', 16.5322 ],
     [ '0.03143140', 0.14561998 ],
     [ '0.03144000', 149.2466 ],
...
     [ '0.03175915', 3.95025486 ],
     [ '0.03176634', 0.01579061 ] ],
  bids: 
   [ [ '0.03141658', 4.75222193 ],
     [ '0.03141644', 0.05252027 ],
     [ '0.03141608', 0.20943191 ],
...
     [ '0.03129457', 0.01861854 ],
     [ '0.03128648', 0.47593681 ] ],
  isFrozen: '0',
  seq: 595100792 }
```

> Example output for all markets:

```json
{ BTC_ETH: 
   { asks: 
      [ [ '0.03143500', 46.84591041 ],
        [ '0.03144000', 100.086388 ],
        [ '0.03144865', 6.01683252 ],
...
        [ '0.03132669', 0.01619218 ] ],
     isFrozen: '0',
     seq: 130962406 },
  BTC_LTC: 
   { asks: 
      [ [ '0.00812000', 6.82726987 ],
        [ '0.00812253', 6.6911383 ],
        [ '0.00812500', 84.1323 ],
...
        [ '1.06900000', 0.0162 ],
        [ '1.06800000', 0.0162 ],
        [ '1.06700000', 0.0162 ] ],
     isFrozen: '0',
     seq: 51055117 } }
```

Returns the order book for a given market, as well as a sequence number used by websockets for synchronization of book updates and an indicator specifying whether the market is frozen. You may set currencyPair to "all" to get the order books of all markets.

Field | Description
------|------------
asks | An array of price aggregated offers in the book ordered from low to high price.
bids | An array of price aggregated bids in the book ordered from high to low price.
isFrozen | Indicates if trading the market is currently disabled or not.
seq | An always-incrementing sequence number for this market.

## returnTradeHistory (public)

```shell
curl "https://poloniex.com/public?command=returnTradeHistory&currencyPair=BTC_ETH"
curl "https://poloniex.com/public?command=returnTradeHistory&currencyPair=BTC_ETH&start=1410158341&end=1410499372"
```

> Example output:

```json
[ { globalTradeID: 394604821,
    tradeID: 45205037,
    date: '2018-10-22 15:03:57',
    type: 'sell',
    rate: '0.03143485',
    amount: '0.00009034',
    total: '0.00000283' },
  { globalTradeID: 394604809,
    tradeID: 45205036,
    date: '2018-10-22 15:03:47',
    type: 'buy',
    rate: '0.03143485',
    amount: '0.00770177',
    total: '0.00024210' },
...
  { globalTradeID: 394603147,
    tradeID: 45204939,
    date: '2018-10-22 14:31:59',
    type: 'sell',
    rate: '0.03139500',
    amount: '0.00041216',
    total: '0.00001293' },
  { globalTradeID: 394603133,
    tradeID: 45204938,
    date: '2018-10-22 14:31:41',
    type: 'sell',
    rate: '0.03140030',
    amount: '2.42099000',
    total: '0.07601981' } ]
```

Returns the past 200 trades for a given market, or up to 50,000 trades between a range specified in UNIX timestamps by the "start" and "end" GET parameters. Fields include:

Field | Description
------|------------
globalTradeID | The globally unique ID associated with this trade.
tradeID | The ID unique only to this currency pair associated with this trade.
date | The UTC date and time of the trade execution.
type | Designates this trade as a `buy` or a `sell` from the side of the taker.
rate | The price in base currency for this asset.
amount | The number of units transacted in this trade.
total | The total price in base units for this trade.

## returnChartData

```shell
curl "https://poloniex.com/public?command=returnChartData&currencyPair=BTC_XMR&start=1405699200&end=9999999999&period=14400"
```

> Example output:

```json
[ { date: 1539864000,
    high: 0.03149999,
    low: 0.031,
    open: 0.03144307,
    close: 0.03124064,
    volume: 64.36480422,
    quoteVolume: 2055.56810329,
    weightedAverage: 0.03131241 },
  { date: 1539878400,
    high: 0.03129379,
    low: 0.03095999,
    open: 0.03124064,
    close: 0.03108499,
    volume: 50.21821153,
    quoteVolume: 1615.31999527,
    weightedAverage: 0.0310887 },
...
  { date: 1540195200,
    high: 0.03160347,
    low: 0.03140002,
    open: 0.031455,
    close: 0.03151499,
    volume: 21.44394862,
    quoteVolume: 681.30276558,
    weightedAverage: 0.03147491 },
  { date: 1540209600,
    high: 0.03153475,
    low: 0.031265,
    open: 0.03151497,
    close: 0.03141781,
    volume: 39.82606009,
    quoteVolume: 1268.53159161,
    weightedAverage: 0.0313954 } ]
```

Returns candlestick chart data. Required GET parameters are "currencyPair", "period" (candlestick period in seconds; valid values are 300, 900, 1800, 7200, 14400, and 86400), "start", and "end". "Start" and "end" are given in UNIX timestamp format and used to specify the date range for the data returned. Fields include:

Field | Description
------|------------
date | The UTC date for this candle in miliseconds since the Unix epoch.
high | The highest price for this asset within this candle.
low | The lowest price for this asset within this candle.
open | The price for this asset at the start of the candle.
close | The price for this asset at the end of the candle.
volume | The total amount of this asset transacted within this candle.
quoteVolume | The total amount of base currency transacted for this asset within this candle.
weightedAverage | The average price paid for this asset within this candle.

## returnCurrencies

```shell
curl "https://poloniex.com/public?command=returnCurrencies"
```

> Example output:

```json
{ '1CR': 
   { id: 1,
     name: '1CRedit',
     txFee: '0.01000000',
     minConf: 10000,
     depositAddress: null,
     disabled: 1,
     delisted: 1,
     frozen: 0 },
  ABY: 
   { id: 2,
     name: 'ArtByte',
     txFee: '0.01000000',
     minConf: 10000,
     depositAddress: null,
     disabled: 1,
     delisted: 1,
     frozen: 0 },
...
  ZEC: 
   { id: 286,
     name: 'Zcash',
     txFee: '0.00100000',
     minConf: 8,
     depositAddress: null,
     disabled: 0,
     delisted: 0,
     frozen: 0 },
  ZRX: 
   { id: 293,
     name: '0x',
     txFee: '5.00000000',
     minConf: 30,
     depositAddress: null,
     disabled: 0,
     delisted: 0,
     frozen: 0 } }
```

Returns information about currencies. Fields include:

Field | Description
------|------------
name | Name of the currency.
txFee | The network fee necessary to withdraw this currency.
minConf | The minimum number of blocks necessary before a deposit can be credited to an account.
depositAddress | If available, the deposit address for this currency.
disabled | Designates whether (1) or not (0) deposits and withdrawals are disabled.
delisted | Designates whether (1) or not (0) this currency has been delisted from the exchange.
frozen | Designates whether (1) or not (0) trading for this currency is disabled for trading.

If the currency lists a deposit address, deposits to that address must be accompanied by a deposit message unique to your account. See the [Balances, Deposits & Withdrawals](https://poloniex.com/balances) page for more information.

## returnLoanOrders

```shell
curl "https://poloniex.com/public?command=returnLoanOrders&currency=BTC"
```

> Example output:

```json
{ offers: 
   [ { rate: '0.00005900',
       amount: '0.01961918',
       rangeMin: 2,
       rangeMax: 2 },
     { rate: '0.00006000',
       amount: '62.24928418',
       rangeMin: 2,
       rangeMax: 2 },
...
     { rate: '0.00007037',
       amount: '0.03083815',
       rangeMin: 2,
       rangeMax: 2 } ],
  demands: 
   [ { rate: '0.02000000',
       amount: '0.00100014',
       rangeMin: 2,
       rangeMax: 2 },
...
     { rate: '0.00001000',
       amount: '0.04190154',
       rangeMin: 2,
       rangeMax: 2 } ] }
```

Returns the list of loan offers and demands for a given currency, specified by the "currency" GET parameter. Fields include:

Field | Description
------|------------
rate | The interest rate in percentage per day charged for this loan.
amount | The total number of units available at this rate and within this range.
rangeMin | The lowest duration in days offered by the loans within this group.
rangeMax | The highest duration in days offered by the loans within this group.
