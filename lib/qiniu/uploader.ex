defmodule Qiniu.Uploader do
  @moduledoc """
  For uploading.
  """

  alias Qiniu.PutPolicy

  @doc """
  Upload a file directly.
  See http://developer.qiniu.com/docs/v6/api/reference/up/upload.html

  ## Example

      put_policy = %Qiniu.PutPolicy{scope: "books", deadline: 1427990400}
      Qiniu.Uploader.upload put_policy, "~/cool.jpg", key: "cool.jpg"

  ## Options

    * `:key` - key name in Qiniu bucket
    * `:crc32` - crc32 to check the file
    * `others` - Custom fields, e.g. `foo: "foo", bar: "bar"`
  """
  def upload(%PutPolicy{}=put_policy, local_file, opts) do
    uptoken = Qiniu.Auth.generate_uptoken(put_policy)
    upload(uptoken, local_file, opts)
  end

  def upload(uptoken, local_file, opts) when is_binary(uptoken) do
    opts = opts
      |> Enum.map(fn {k, v} -> {to_string(k), v} end)
      |> Enum.filter(fn {k, v} -> v != nil end)
    data = List.flatten opts, [{:file, local_file}, {"token", uptoken}]
    post_data = {:multipart, data}

    Qiniu.HTTP.post(Qiniu.config[:up_host], post_data)
  end
end
