defmodule Qiniu.Auth do
  @moduledoc """
  Module about authorization.

  See http://developer.qiniu.com/docs/v6/api/reference/security/
  """

  alias Qiniu.PutPolicy

  @doc """
  Generate token for uploading, which can be used in client or just server.

  See http://developer.qiniu.com/docs/v6/api/reference/security/upload-token.html

  ## Examples

      policy = Qiniu.PutPolicy.build("scope")
      uptoken = Qiniu.Auth.generate_uptoken(policy)
  """
  @spec generate_uptoken(Qiniu.PutPolicy.t) :: String.t
  def generate_uptoken(%PutPolicy{} = put_policy) do
    [access_key: access_key, secret_key: secret_key] =
      Keyword.take(Qiniu.config, [:access_key, :secret_key])

    encoded_put_policy = PutPolicy.encoded_json put_policy
    encoded_sign = hex_digest(secret_key, encoded_put_policy)

    "#{access_key}:#{encoded_sign}:#{encoded_put_policy}"
  end

  @doc """
  Get authorized download url from host and key

  ## Fields

    * host - e.g. http://my-bucket.qiniudn.com
    * key  - e.g. prefix/sunflower.jpg
    * expires_in - seconds to expire
  """
  def authorize_download_url(host, key, expires_in) do
    authorize_download_url(host <> "/" <> key, expires_in)
  end

  @doc """
  Get authorized download url from plain url(host + key)

  ## Fields

    * url - e.g. http://my-bucket.qiniudn.com/prefix/sunflower.jpg
    * expires_in - seconds to expire

  """
  def authorize_download_url(url, expires_in) do
    deadline = Qiniu.Utils.calculate_deadline(expires_in)

    parsed = url |> URI.encode |> URI.parse
    query = (parsed.query || "") |> URI.decode_query |> Map.merge(%{"e" => deadline}) |> URI.encode_query

    download_url = %{parsed | query: query} |> to_string

    [access_key: access_key, secret_key: secret_key] =
      Keyword.take(Qiniu.config, [:access_key, :secret_key])

    encoded_sign = hex_digest(secret_key, download_url)
    down_token = access_key <> ":" <> encoded_sign

    "#{download_url}&token=#{down_token}"
  end

  @doc false
  def hex_digest(key, data) when is_binary(key) and is_binary(data) do
    :crypto.hmac(:sha, key, data) |> Base.url_encode64
  end
end
