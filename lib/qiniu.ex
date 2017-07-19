defmodule Qiniu do
  @moduledoc """
  Top module of this package. For configuration at this moment.
  """

  @doc """
  Get config data.

  ## Examples

  Config in your config.exs

      config :qiniu, Qiniu,
        access_key: "key",
        secret_key: "secret"

  You can fetch the config if you want as

      Qiniu.config[:access_key]

  """
  def config do
    Keyword.merge(default_config(), Application.get_env(:qiniu, Qiniu, []))
  end

  defp default_config do
    [
      user_agent:       "QiniuElixir/#{System.version}",
      content_type:     "application/x-www-form-urlencoded",
      up_host:          "http://up.qiniu.com",
      rs_host:          "http://rs.qiniu.com",
      rsf_host:         "http://rsf.qbox.me",
      io_host:          "http://iovip.qbox.me",
      api_host:         "http://api.qiniu.com"
    ]
  end
end
