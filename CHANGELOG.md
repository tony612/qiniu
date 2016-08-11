# Changelog

## v0.3.3 (2016-08-11)

* parse HTTP response by default

## v0.3.2 (2016-08-02)

* transform keys of PutPolicy to camelCase. Thanks @goofansu for finding the issue #4

## v0.3.1 (2016-07-04)

* update poison version to "~> 2.0"

## v0.3.0 (2016-05-11)

* drop support for Erlang 17 and Elixir 1.1
* change `:key` of Qiniu.Uploader.upload/3 to optional based on Qiniu API doc
* add tests for Qiniu.Uploader

## v0.2.2 (2016-01-07)

* support Erlang 18 and Elixir 1.1 & 1.2

## v0.2.1 (2015-06-12)

* add more tests
* bug fix

## v0.2.0 (2015-05-23)

* add Qiniu.PutPolicy/build
* add doc and more functions to Qiniu.Auth
* add Qiniu.Resource
* add Qiniu.Fop
* add Qiniu.Fop.Image
* change `key` of `upload` to a required param instead of an option

## v0.1.2 (2015-4-5)

* Change default user_agent

## v0.1.1 (2015-4-4)

* Fix the config in read project

## v0.1.0 (2015-4-2)

* Uploading directly
