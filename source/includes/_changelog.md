# Changelog

Recent changes and additions to the Poloniex API.

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
