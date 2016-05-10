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
      Qiniu.Uploader.upload put_policy, "~/cool.jpg", "cool.jpg"
      # =>
      %HTTPoison.Response{
        body: "body",
        headers: %{"connection" => "keep-alive", "content-length" => "517", ...},
        status_code: 200
      }

  ## Fields

    * `put_policy` - PutPolicy struct
    * `local_file` - path of local file

  ## Options
    * `:key`   - file name in a Qiniu bucket
    * `:crc32` - crc32 to check the file
    * `others` - Custom fields `atom: "string"`, e.g. `foo: "foo", bar: "bar"`
  """
  def upload(put_policy, local_file, opts \\ [])

  def upload(%PutPolicy{}=put_policy, local_file, opts) do
    uptoken = Qiniu.Auth.generate_uptoken(put_policy)
    upload(uptoken, local_file, opts)
  end

  def upload(uptoken, local_file, opts) when is_binary(uptoken) do
    opts = opts
      |> Enum.map(fn {k, v} -> {to_string(k), v} end)
      |> Enum.filter(fn {_, v} -> v != nil end)
    data = List.flatten opts, [{:file, local_file}, {"token", uptoken}]
    post_data = {:multipart, data}

    Qiniu.HTTP.post(Qiniu.config[:up_host], post_data)
  end
end
