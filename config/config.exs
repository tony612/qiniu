use Mix.Config

config :qiniu, Qiniu,
  user_agent:       "QiniuElixir/#{Qiniu.Mixfile.project[:version]}/Ruby/#{System.version}",
  content_type:     "application/x-www-form-urlencoded",
  up_host:          "http://up.qiniu.com",
  access_key:       "key",
  secret_key:       "secret"
