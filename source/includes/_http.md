# HTTP API

The HTTP API allows read access to public market data through the public endpoint and read / write access to your private account via the private endpoint.

* Public HTTP Endpoint: `https://poloniex.com/public`
* Private HTTP Endpoint: `https://poloniex.com/tradingApi`

Please note that there is a default limit of 6 calls per second. If you require more than this, please consider optimizing your application using the websocket-based push API, the "moveOrder" command, or the "all" parameter where appropriate.

Making more than 6 calls per second to the API, or repeatedly and needlessly fetching excessive amounts of data, can result in  rate limit. Please be careful.

<aside class="notice">
If your account's volume is over $5 million in 30 day volume, you may be eligible for an API rate limit increase. Please email poloniex@circle.com.
</aside>
