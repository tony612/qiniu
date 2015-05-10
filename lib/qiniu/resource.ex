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

  @doc """
  Copy one entry to another dest key

  ## Fields

    * `source_uri` - uri of your source entry, "<bucket>:<key>"
    * `dest_uri` - uri of your dest entry, "<bucket>:<key>"
  """
  def copy(source_uri, dest_uri) do
    encoded_source = Base.url_encode64(source_uri)
    encoded_dest = Base.url_encode64(dest_uri)
    url = Path.join([Qiniu.config[:rs_host], "copy", encoded_source, encoded_dest])
    auth_post(url)
  end

  @doc """
  Move an entry to another dest

  ## Fields

    * `source_uri` - uri of your source entry, "<bucket>:<key>"
    * `dest_uri` - uri of your dest entry, "<bucket>:<key>"
  """
  def move(source_uri, dest_uri) do
    encoded_source = Base.url_encode64(source_uri)
    encoded_dest = Base.url_encode64(dest_uri)
    url = Path.join([Qiniu.config[:rs_host], "move", encoded_source, encoded_dest])
    auth_post(url)
  end

  @doc """
  Delete an entry

  ## Fields

    * `uri` - uri of your entry to delete, "<bucket>:<key>"
  """
  def delete(uri) do
    url = Path.join([Qiniu.config[:rs_host], "stat", Base.url_encode64(uri)])
    auth_post(url)
  end

  @doc """
  List resources in one bucket

  ## Fields

    * `bucket` - the bucket to list

  ## Options

    * `:limit` - Number to list(1~1000), default is 1000
    * `:prefix` - Prefix of resources to list, default is `""`
    * `:delimiter` - Directory separator to list common prefix, default is `""`
    * `:marker` - Marker of last request, which can act as starting point of
      this request, default is `""`
  """
  def list(bucket, opts \\ []) do
    opts = Keyword.put(opts, :bucket, bucket)
    params = Enum.map_join(opts, "&", fn({k, v}) -> "#{k}=#{v}" end)

    url = Path.join([Qiniu.config[:rsf_host], "list?#{params}"])
    auth_post(url)
  end

  defp auth_post(url, body \\ "") do
    Qiniu.HTTP.post url, body, headers: [
      Authorization: "QBox " <> Qiniu.Auth.access_token(url, body)
    ]
  end
end
