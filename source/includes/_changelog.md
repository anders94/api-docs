# Changelog

Recent changes and additions to the Poloniex API.

## 2020-01-16 ETHBNT Listing
Listing of Bancor ETH Smart Token Relay (ETHBNT) and the folowing market BTC_ETHBNT.

## 2019-12-30 Currency delistings
Delisting DigiByte (DGB), Factom (FCT), MaidSafeCoin (MAID), Omni (OMNI), Primecoin (XPM), Vertcoin (VTC) and Viacoin (VIA)

## 2019-11-19 Cancel order by clientOrderId
This change allows users to cancel both pending and open orders by `clientOrderId`.

## 2019-11-12 TRX Listing
Listing of Tron (TRX) and the folowing markets BTC_TRX, USDC_TRX and USDT_TRX.

## 2019-10-15 Currency delistings
Delisting Pascal (PASC), Steem (STEEM), Navcoin (NAV), GameCredits (GAME), LBRY Credits (LBC), and Clams (CLAM).

## 2019-08-20 Updates to clientOrderId documentation
Fixed newly introduced grammar issues for clientOrderID docs

## 2019-08-16 XMR base delisting
XMR as a base was delisted, along with other pairs. See tweet for details - https://twitter.com/Poloniex/status/1162061407858417664

## 2019-08-06 "k" and "p" account notifications
Introducing "k" (killed) and "p" (pending order) channel 1000 websocket account notifications

## 2019-07-29 Updates to clientOrderId documentation
State clientOrderId is 64 bit integer, and when live, must be unique per account

## 2019-07-24 Add clientOrderId to private http methods and websocket messages
Some endpoints now support using a client specified integer identifier which will be returned in http responses and "o", "t", "n" websocket messages.

## 2019-07-12 Newly listed USDC/T market IDs
Add recently listed market IDs to currency pair IDs list

## 2019-06-26 Add currencyToWithdrawAs to withdraw
Include the `currencyToWithdrawAs` parameter to the withdrawal API call (used to withdraw USDTTRON).

## 2019-06-13 Add adjustments to returnDepositWithdrawals
Include special adjustments (e.g. Stellar inflation credits) as part of the returnDepositWithdrawals response.

## 2019-06-12 Update returnTradeHistory response to reflect new max
The max number of trades that can be fetched in a single call has been reduced to 1,000.

## 2019-06-12 Additional fields to channel 1000 o message
Channel 1000 `o` message has been appended to include the `orderType` field at the end of the response.

## 2019-06-04 cancelAllOrders trading method added
This new API method allows users to cancel all open orders or all open orders by currencyPair.

## 2019-05-09 Additional fields to channel 1000 t message
Channel 1000 `t` message has been appended to include the total `fee` and `date` at the end of the response respectively.

## 2019-05-08 Additional fields to buy and sell response
The buy and sell response will now include `currencyPair` and `fee` multiplier.

## 2019-04-04 Additional fields to returnDepositsWithdrawals response.

Document inclusion of new `depositNumber` field for deposits and `paymentID` field for withdrawals in returnDepositsWithdrawals response.

## 2019-03-29 TLS 1.2 or greater required.

As of April 15, 2019, TLS version 1.2 or greater is required.

## 2019-03-28 Add minimize latency instructions.

Instructions on how to minimize latency have been added to the Getting Started section.

## 2019-03-22 Margin parameters clarified.

In both "marginBuy" and "marginSell", the "rate" parameter definition has been fixed. Additionally, the optional "lendingRate" parameter has been defined and a note was added about the default value and minimum setting.

## 2018-12-27 API documentation overhaul

Refreshed look & feel and adds example code via the shell.

## 2018-09-25 Order status trading method added

Returns the status of a given order.

## 2018-09-16 Account notification channel added

The account notifications channel provides real-time updates of trade and balance changes on your account.
