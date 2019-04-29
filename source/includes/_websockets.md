# Websocket API

```shell
# Install your favorite websocket command line tool.
# Our examples use https://github.com/hashrocket/ws
# which can be installed with this command:

go get -u github.com/hashrocket/ws
```

Websockets can be read by any standard websocket library. Data is organized into channels to which an API client may subscribe.

<aside class="notice">
Websocket URL: `wss://api2.poloniex.com`
</aside>

## Requests and Responses

There are two type of requests supported; subscribe and unsubscribe. The requests are for a specific channel. For non-book requests, the first response is always an acknowledgement of the request. All channel updates are of the following format

`[<channel>, <sequence id>, <update data...>]`

`<sequence id>` is a number increasing by one with each update and is unique within its channel. The sequence-id is always null for non-book channels.

## Subscribing and Unsubscribing

```shell
# Public channels
ws wss://api2.poloniex.com
> {"command": "subscribe", "channel": 1002}

# Private channels
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "nonce=154264078495300" | openssl sha512 -hmac $API_SECRET
ws wss://api2.poloniex.com
> {"command": "subscribe", "channel": 1000, "sign": "e832d65f...8a522df8", "key": "7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J", "payload": "nonce=154264078495300"}
```

To receive updates from a channel you must subscribe to it. To subscribe to a public channel (all except the account notifications channel), determine its channel ID (provided with the description of each channel, and summarized here), send a JSON message in the following format:

`{ "command": "subscribe", "channel": "<channel id>" }`

To subscribe to a private channel, the parameters described in the authentication section are required in the subscription message. Just like the trading API, an integer nonce must be chosen that is greater than the previous nonce used; for this purpose the current epoch time in milliseconds is a reasonable choice. As each API key has its own nonce tracking, using a different keys for each client process can greatly simplify nonce management. If the chosen nonce is 1234, provide a "payload" parameter consisting of nonce=1234, a "key" parameter with your API key, and a "sign" parameter with the HMAC-SHA512 signature of the payload signed by your secret:

`{ "command": "subscribe", "channel": "<channel id>", "key": "<your API key>", "payload": "nonce=<epoch ms>", "sign": "<hmac_sha512(secret).update("nonce=<epoch ms>").hexdigest()>" }`

In all cases the first message will be an acknowledgement of the subscription:

`[<channel id>, 1]`

To unsubscribe, send an unsubscribe message with the channel ID:

`{ "command": "unsubscribe", "channel": <channel id> }`

## Channel Descriptions

The following `<channel ids>` are supported:

Channel | Type | Name
--------|------|-----
1000 | Private | Account Notifications (Beta)
1002 | Public | Ticker Data
1003 | Public | 24 Hour Exchange Volume
1010 | Public | Heartbeat
&lt;currency pair&gt; | Public | Price Aggregated Book

Additionally, as described below, each market has its own aggregated book channel.

## Account Notifications (Beta)

```shell
# Note: set the nonce to the current milliseconds. For example: date +%s00000
echo -n "nonce=154264078495300" | openssl sha512 -hmac $API_SECRET
ws wss://api2.poloniex.com
> {"command": "subscribe", "channel": 1000, "sign": "e832d65f...8a522df8", "key": "7BCLAZQZ-HKLK9K6U-3MP1RNV9-2LS1L33J", "payload": "nonce=154264078495300"}
< [1010]
< [1000,"",[["n",225,807230187,0,"1000.00000000","0.10000000","2018-11-07 16:42:42"],["b",267,"e","-0.10000000"]]]
< [1010]
< [1000,"",[["o",807230187,"0.00000000"],["b",267,"e","0.10000000"]]]
```

<aside class="notice">
Notice: Before using this channel, please be aware that it is a beta feature. We will not make breaking API changes, but we may undertake changes such as adding extra data fields to the ends of arrays, or adding new message types. Your code should be tolerant of this. We have made all reasonable efforts to ensure its correctness, but you use this channel at your own risk during the beta phase.
</aside>

The account notifications channel (id `1000`) provides real-time updates of trade and balance changes on your account. You can (and should) use it to track your account's trading activity (instead of relying on repeated calls to the trading API). It is an authenticated websocket endpoint, so subscribing to it requires the parameters discussed in the subscribing section:

`{ "command": "subscribe", "channel": "1000", "key": "<your API key>", "payload": "nonce=<epoch ms>", "sign": "<hmac_sha512(secret).update("nonce=<epoch ms>").hexdigest()>" }`

The first message is acknowledgement of the subscription.

`[1000, 1]`

Subsequent messages represent updates to your account. In general, a message consists of a combination of updates of different types. Each update is an array of data, where the first element is a character denoting the type of the update, and subsequent elements are various parameters:

`[ 1000, null, [ ["b", DATA_1, DATA_2, DATA_3], ["n", DATA_1, DATA_2, DATA_3, DATA_4, DATA_5, DATA_6] ] ]`

A given message may contain multiple updates, multiple types of updates, and multiple updates of the same type. There is no ordering guarantee of update types within a single message. Effectively, each message is a record of all of the changes to your account induced by a single action. There are four types of updates, as described below:

* `b` updates represent an available balance update. They are in the format `["b", <currency id>, "<wallet>", "<amount>"]`. Currency IDs may be found in the reference table, or using the returnCurrencies REST call. The wallet can be `e` (exchange), `m` (margin), or `l` (lending). Thus, a `b` update representing a deduction of 0.06 BTC from the exchange wallet will look like `["b", 28, "e", "-0.06000000"]`.
* `n` updates represent a newly created limit order. They are in the format `["n", <currency pair id>, <order number>, <order type>, "<rate>", "<amount>", "<date>"]`. Currency pair IDs are described here, the order type can either be `0` (sell) or `1` (buy), and the date is formatted according to the format string `Y-m-d H:i:s`. Thus, an `n` update representing a buy order for 2 ETH at rate 0.03 BTC per ETH will look like `["n", 148, 6083059, 1, "0.03000000", "2.00000000", "2018-09-08 04:54:09"]`.
* `o` updates represent an order update. They are in the format `["o", <order number>, "<new amount>"]`
  A cancelled or completely filled order is denoted with a "0.00000000" amount. Thus, an `o` update representing a partially filled limit order with a new amount of 1.5 will look like:
  `["o", 6083059, "1.50000000"]`
* `t` updates represent a trade notification. They are in the format `["t", <trade ID>, "<rate>", "<amount>", "<fee multiplier>", <funding type>, <order number>]`. The fee multiplier is the fee schedule applied to the trade (for instance, if a trade had a trading fee of 0.25%, the fee multiplier will be '0.00250000'). The funding type represents the funding used for the trade, and may be `0` (exchange wallet), `1` (borrowed funds), `2` (margin funds), or `3` (lending funds). Note that while the trade ID will always be distinct, the order number may be shared across multiple `t` updates if multiple trades were required to fill a limit order. A `t` update representing a purchase of 0.5 ETH at rate 0.03 BTC per ETH using exchange funds with a fee schedule of 0.25% will look like:
  `["t", 12345, "0.03000000", "0.50000000", '0.00250000', 0, 6083059]`

As mentioned above, a single logical action may cause a message with multiple updates. For instance, placing a limit order to buy ETH using BTC, which is immediately partially fulfilled, will cause an update with 4 parts: a `b` update with a positive ETH balance (the ETH that was immediately bought), a `b` update with a negative BTC balance update (the BTC removed from the user's funds to pay for the ETH), a `t` update representing the trade in which the order was partially fulfilled, and an `n` update with the new limit order for the rest of the requested ETH.

Note that many actions do not have explicit notification types, but rather are represented by the underlying trade and balance changes:

* Stop-limit orders immediately cause a `b` notification (that the appropriate balance has been decremented to reserve an asset for the limit order). When they are triggered they cause notifications commensurate with a standard limit order being placed (`n` or `t` updates depending on whether the limit was immediately fulfilled).
* Margin liquidations cause a notification with `t` updates for whatever trades were performed during the liquidation, and `b` updates for the `m` (margin) wallet balance changes.
* Accepted loan offers cause a notification with `b` updates for the resulting `l` (lending) wallet balance changes.

There are currently no notifications of transfers between wallets initiated via the transfers page or the transferBalance trading API call.

## Ticker Data

```shell
ws wss://api2.poloniex.com
> {"command": "subscribe", "channel": 1002}
< [1002,1]
< [1002,null,[149,"219.42870877","219.85995997","219.00000016","0.01830508","1617829.38863451","7334.31837942",0,"224.44803729","214.87902002"]]
< [1002,null,[150,"0.00000098","0.00000099","0.00000098","0.01030927","23.24910068","23685243.40788439",0,"0.00000100","0.00000096"]]
< [1002,null,[162,"0.00627869","0.00630521","0.00627608","0.01665689","17.99294312","2849.74975814",0,"0.00640264","0.00615185"]]
```

Subscribe to ticker updates for all currency pairs.

Subscription example

`{ "command": "subscribe", "channel": 1002 }`

The first message is acknowledgement of the subscription.

`[<id>, 1]`

Subsequent messages are ticker updates.

`[ <id>, null, [ <currency pair id>, "<last trade price>", "<lowest ask>", "<highest bid>", "<percent change in last 24 hours>", "<base currency volume in last 24 hours>", "<quote currency volume in last 24 hours>", <is frozen>, "<highest trade price in last 24 hours>", "<lowest trade price in last 24 hours>" ], ... ]`

For example:

`[ 1002, null, [ 149, "382.98901522", "381.99755898", "379.41296309", "-0.04312950", "14969820.94951828", "38859.58435407", 0, "412.25844455", "364.56122072" ] ]`

The `<currency pair id>` is from the [currency pair ID list](?shell#reference).

## 24 Hour Exchange Volume

```shell
ws wss://api2.poloniex.com
> {"command": "subscribe", "channel": 1003}
< [1003,null,["2018-11-07 16:26",5804,{"BTC":"3418.409","ETH":"2645.921","XMR":"111.287","USDT":"10832502.689","USDC":"1578020.908"}]]
```

Subscribe to 24 hour exchange volume statistics. Updates are sent every 20 seconds.

Subscription example for exchange volume

`{ "command": "subscribe", "channel": 1003 }`

The first response is acknowledgement of subscription

`[<channel id>, 1]`

For example:

`[1003, 1]`

Subsequent responses are exchange volume update sent every 20 seconds. Base currencies are BTC, ETH, XMR, USDT and USDC.

`[ <channel id>, null, [ "<time as YYYY-MM-DD HH:SS>", "<number of users online>", { "<base currency>": "<24 hours volume>", ... } ] ]`

For example

`[ 1003, null, [ "2018-09-30 21:33", 8592, { "BTC": "6482.518", "ETH": "1315.332", "XMR": "179.914", "USDT": "42935638.731", "USDC": "76034823.390" } ] ]`

## Heartbeats

```shell
# Heartbeats (1010) will arrive automatically - you can see them simply by connecting
ws wss://api2.poloniex.com
< [1010]
< [1010]
< [1010]
```

When no messages have been sent out for one second, the server will send a heartbeat message as follows. Absence of heartbeats indicates a protocol or networking issue and the client application is expected to close the socket and try again.

`[1010]`

## Price Aggregated Book

```shell
ws wss://api2.poloniex.com
> {"command": "subscribe", "channel": "BTC_ETH"}
< [148,599758718,[["i",{"currencyPair":"BTC_ETH","orderBook":[{"0.03342499":"0.98174196","0.03343000":"45.80780000", ... "0.00000001":"1462262.00000000"}]}]]]
< [148,599758719,[["o",1,"0.03315496","0.00000000"],["o",1,"0.03315498","99.33100000"]]]
< [148,599758720,[["o",0,"0.03383499","0.00000000"]]]
< [148,599758721,[["o",0,"0.03342499","0.24289338"]]]
```

> Example output:

```
  { currencyPair: 'BTC_ETH',
    orderBook:
     [ { '0.03119500': '8.87619723',
         '0.03120486': '2.15539849',
         '0.03120500': '50.78890000',
...
         '3777.70000000': '0.00100000',
         '4999.00000000': '0.05000000',
         '5000.00000000': '0.20000000' },
       { '0.03118500': '50.78940000',
         '0.03117855': '10.55121501',
         '0.03117841': '6.20027213',
...
         '0.00000003': '20000.00000000',
         '0.00000002': '670207.00000000',
         '0.00000001': '1462262.00000000' } ] } ]
```
	 
Subscribe to price aggregated depth of book by [currency pair](#currency-pair-ids). Response includes an initial book snapshot, book modifications, and trades. Book modification updates with 0 quantity should be treated as removal of the price level. Note that the updates are price aggregated and do not contain individual orders.

Subscription example for BTC_BTS pair (id is 14). You can either subscribe using the currency pair ID or name. Currency pair IDs are listed in the [currency pair ID list](#currency-pair-ids).

`{ "command":"subscribe", "channel": 14 }`

Or

`{ "command": "subscribe", "channel": "BTC_BTS" }`

The first response is the initial dump of the book

`[ <channel id>, <sequence number>, [ [ "i", { "currencyPair": "<currency pair name>", "orderBook": [ { "<lowest ask price>": "<lowest ask size>", "<next ask price>": "<next ask size>", ... }, { "<highest bid price>": "<highest bid size>", "<next bid price>": "<next bid size>", ... } ] } ] ] ]`

For example:

`[ 14, 8767, [ [ "i", { "currencyPair": "BTC_BTS", "orderBook": [ { "0.00001853": "2537.5637", "0.00001854": "1567238.172367" }, { "0.00001841": "3645.3647", "0.00001840": "1637.3647" } ] } ] ] ]`

Subsequent responses are updates to the book and trades

`[ <channel id>, <sequence number>, [ ["o", <1 for buy 0 for sell>, "<price>", "<size>"], ["o", <1 for buy 0 for sell>, "<price>", "<size>"], ["t", "<trade id>", <1 for buy 0 for sell>, "<price>", "<size>", <timestamp>] ] ... ]`

For example

`[ 14, 8768, [ ["o", 1, "0.00001823", "5534.6474"], ["o", 0, "0.00001824", "6575.464"], ["t", "42706057", 1, "0.05567134", "0.00181421", 1522877119] ] ]`
