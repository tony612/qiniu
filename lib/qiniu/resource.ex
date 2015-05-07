defmodule Qiniu.Resource do
  @moduledoc """
  Module to managing resource

  See http://developer.qiniu.com/docs/v6/api/reference/rs/
  """

  def stat(bucket, key) do
    encoded_entry = Base.url_encode64(bucket <> ":" <> key)
    url = Path.join([Qiniu.config[:rs_host], "stat", encoded_entry])
    auth_post(url, "")
  end

  defp auth_post(url, body) do
    Qiniu.HTTP.post url, body, parse: true, headers: [
      Authorization: "QBox " <> Qiniu.Auth.access_token(url, body)
    ]
  end
end
