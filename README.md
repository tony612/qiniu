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

### Upload

Get the token for uploading

```elixir
policy = Qiniu.PutPolicy.build("scope")
uptoken = Qiniu.Auth.generate_uptoken(policy)
```

Upload a local file in server

```elixir
put_policy = Qiniu.PutPolicy("books")
Qiniu.Uploader.upload put_policy, "~/cool.jpg", key: "cool.jpg"
```

### Download

Get the authorized download url

```elixir
Qiniu.Auth.authorize_download_url(url, 3600)
```

See the [doc](http://hexdocs.pm/qiniu/) for detail

### TODO

Uploading

- [x] 直传文件（upload）
- [ ] 创建块（mkblk）
- [ ] 上传片（bput）
- [ ] 创建文件（bput）

Resource management

- [x] 获取资源信息（stat）
- [x] 复制资源（copy）
- [x] 移动资源（move）
- [x] 删除资源（delete）
- [ ] 批量操作（batch）
- [x] 列举资源（list）
- [x] 抓取资源（fetch）
- [x] 更新镜像资源（prefetch）
- [ ] 修改元信息（chgm）
