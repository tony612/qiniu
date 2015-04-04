Qiniu
=====

[![Build Status](https://travis-ci.org/tony612/qiniu.svg?branch=master)](https://travis-ci.org/tony612/qiniu)
[![Inline docs](http://inch-ci.org/github/tony612/qiniu.svg?branch=master)](http://inch-ci.org/github/tony612/qiniu)
[![hex.pm version](https://img.shields.io/hexpm/v/qiniu.svg)](https://hex.pm/packages/qiniu)

Qiniu sdk for Elixir

## Usage

Config the keys

```elixir
# config.exs
config :qiniu, Qiniu,
  access_key: "key",
  secret_key: "secret"
```

Upload a local file

```elixir
put_policy = %Qiniu.PutPolicy{scope: "books", deadline: 1427990400}
Qiniu.Uploader.upload put_policy, "~/cool.jpg", key: "cool.jpg"
```

See the [doc](http://hexdocs.pm/qiniu/) for detail
