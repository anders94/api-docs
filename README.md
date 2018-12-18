Poloniex API Documentation
==========================

This repository holds the `slate` based documentation for the Poloniex HTTP and Websocket based public facing API.
This is a complete content rewrite of the documentation without changes to the API's functionality.

Prerequisites
-------------

* ruby 2.3.1 or newer
* bundler

If you need bundler:

```shell
gem install bundler
```

Initialize
----------

```shell
git clone https://github.com/poloniex/api-docs
cd api-docs/
bundle install
```

Run
---

```shell
bundle exec middleman server
```

See
---

Navigate to http://localhost:4567

Edits
-----

All content lives in [source/](source/). Each section is an included file in the [source/includes/](source/includes/)
directory. Once you have edited a file, reloading the browser will show the incorporated changes.

Deploy
------

To deploy a set of flat files:

```bundle exec middleman build --clean```

Everything should end up in the `build/` directory.
