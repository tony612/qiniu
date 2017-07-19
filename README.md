Qiniu
=====

[![Build Status](https://travis-ci.org/tony612/qiniu.svg?branch=master)](https://travis-ci.org/tony612/qiniu)
[![Coverage Status](https://coveralls.io/repos/github/tony612/qiniu/badge.svg?branch=master)](https://coveralls.io/github/tony612/qiniu?branch=master)
[![Inline docs](http://inch-ci.org/github/tony612/qiniu.svg?branch=master)](http://inch-ci.org/github/tony612/qiniu)
[![hex.pm version](https://img.shields.io/hexpm/v/qiniu.svg)](https://hex.pm/packages/qiniu)

[Qiniu](http://www.qiniu.com) sdk for Elixir

## Installation and config

* Add qiniu as dependence and application

```elixir
# mix.exs
def application do
  [applications: [:qiniu]]
end

defp deps do
  [{:qiniu, "~> 0.3.0"}]
end
```

Then run `$ mix deps.get`

* Config the Qiniu API keys

```elixir
# config/prod.secret.exs (You'd better not add this file to git)
config :qiniu, Qiniu,
  access_key: "key",
  secret_key: "secret"
```

## Usage

### Upload

Get the token for uploading

```elixir
policy = Qiniu.PutPolicy.build("scope")
uptoken = Qiniu.Auth.generate_uptoken(policy)
```

Upload a local file in server

```elixir
put_policy = Qiniu.PutPolicy.build("books")
Qiniu.Uploader.upload put_policy, "~/cool.jpg", key: "cool.jpg"
```

Chunked upload

```elixir
put_policy = Qiniu.PutPolicy.build("books")
Qiniu.ChunkUpload.chunk_upload put_policy, "~/cool.jpg", key: "cool.jpg"
```

### Download

Get the authorized download url

```elixir
Qiniu.Auth.authorize_download_url(url, 3600)
```

### Media Processing

AV transcoding

```elixir
Qiniu.Fop.AV.trans_fops([avthumb: "mp4", s: "640x360", saveas: "bucket1:test.mp4"])
```

**See the [doc](http://hexdocs.pm/qiniu/) for other features**

### TODO

There're many small features, implements of which are bothering.
And some of them seem not very useful. So I don't plan to implement all of them
until I find some useful. You can create issues when you need some features
or just implement them by yourself.

- [x] Uploading
  - [x] 直传文件（upload）
  - [x] 创建块（mkblk）
  - [x] 上传片（bput）
  - [x] 创建文件（bput）
- [x] Resource management
  - [x] 获取资源信息（stat）
  - [x] 复制资源（copy）
  - [x] 移动资源（move）
  - [x] 删除资源（delete）
  - [x] 批量操作（batch）
  - [x] 列举资源（list）
  - [x] 抓取资源（fetch）
  - [x] 更新镜像资源（prefetch）
  - [x] 修改元信息（chgm）
- [ ] Data handling
  - [ ] Image
    - [x] 图片基本信息（info）
    - [x] 图片EXIF信息（exif）
    - [x] 水印（watermark）
    - [x] 图片主色调（avg_hue）
  - [x] 资源下载二维码（qrcode）
