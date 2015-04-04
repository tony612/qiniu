defmodule Qiniu do
  def config do
    Keyword.merge(default_config, Application.get_env(:qiniu, Qiniu, []))
  end

  defp default_config do
    [
      user_agent:       "QiniuElixir/#{Qiniu.Mixfile.project[:version]}/Ruby/#{System.version}",
      content_type:     "application/x-www-form-urlencoded",
      up_host:          "http://up.qiniu.com",
    ]
  end
end
