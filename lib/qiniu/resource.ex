defmodule Qiniu.Resource do
  @moduledoc """
  Module to managing resource

  See http://developer.qiniu.com/docs/v6/api/reference/rs/
  """

  @doc """
  Get the metadata of the resource

  ## Fields

    * `entry_uri` - uri of your resource entry, "<bucket>:<key>"
  """
  def stat(entry_uri) do
    encoded_entry = Base.url_encode64(entry_uri)
    url = Path.join([Qiniu.config[:rs_host], "stat", encoded_entry])
    auth_post(url)
  end

  defp auth_post(url, body \\ "") do
    Qiniu.HTTP.post url, body, headers: [
      Authorization: "QBox " <> Qiniu.Auth.access_token(url, body)
    ]
  end
end
