defmodule Qiniu.ChunkUpload do
  @moduledoc """
  For chunked uploading.
  """

  alias Qiniu.PutPolicy

  @default_block_size 1024 * 1024 * 4

  @default_chunk_size 1024 * 1024


  @doc """
  Qiniu chunked upload:
  https://developer.qiniu.com/kodo/manual/1650/chunked-upload

  ## Options
    * `:key`   - file name in a Qiniu bucket
    * `:mimeType`   - file name in a Qiniu bucket
  """
  def chunk_upload(put_policy, local_file, opts \\ [])
  def chunk_upload(%PutPolicy{}=put_policy, local_file, opts) do
    uptoken = Qiniu.Auth.generate_uptoken(put_policy)
    chunk_upload(uptoken, local_file, opts)
  end
  def chunk_upload(uptoken, local_file, opts) when is_binary(uptoken) do
    case File.stat(local_file) do
      {:ok, %{size: file_size, type: :regular}} ->
        File.stream!(local_file, [], @default_block_size)
        |> Stream.map(fn(blk) ->
          blk
          |> chop(@default_chunk_size)
          |> send_block(byte_size(blk), opts, uptoken)
        end)
        |> Enum.join(",")
        |> mkfile(file_size, opts, uptoken)
      {:ok, %{type: type}} ->
        {:error, "Expect a regular file, `#{local_file}` is a #{type}"}
      {:error, :enoent} ->
        {:error, "Can not found the file `#{local_file}`"}
      error -> error
    end
  end

  def send_block([chunk | rest], block_size, opts, uptoken) do
    case mkblk(chunk, opts, uptoken, block_size) do
      %HTTPoison.Response{body: %{"ctx" => ctx, "host" => host}} ->
        send_chunk(rest, 1, ctx, uptoken, host)
      error ->
        error
    end
  end

  def send_chunk([], _offset, ctx, _uptoken, _host), do: ctx
  def send_chunk([chunk | rest], offset, ctx, uptoken, host) do
    case bput(chunk, offset, ctx, uptoken, host) do
      %HTTPoison.Response{body: %{"ctx" => ctx, "host" => host}} ->
                      send_chunk(rest, offset + 1, ctx, uptoken, host)
      error -> error
    end
  end

  @doc """
  chop block into chunks with default chunk size as 1MB

  ## Examples
      iex> ChunkUpload.chop("1234", 1)
      ["1", "2", "3", "4"]

  """
  def chop(chunks, chunk_size, acc \\ [])
  def chop(chunks, chunk_size, acc) when byte_size(chunks) > chunk_size do
    <<chunk :: binary-size(chunk_size), rest :: binary>> = chunks
    chop(rest, chunk_size, [chunk | acc])
  end
  def chop(chunks, _size, acc) do
    Enum.reverse([chunks | acc])
  end

  def mkblk(stream, opts, uptoken, block_size) do
    headers = Keyword.merge(opts[:headers] || [], [
      content_type: "application/octet-stream",
      content_length: byte_size(stream),
      authorization: "UpToken " <> uptoken,
    ])

    url = Qiniu.config[:up_host] <> "/mkblk/#{block_size}"
    post_with_retry(url, stream, %{headers: headers})
  end

  def bput(stream, offset, ctx, uptoken, host \\ "") do
    headers = [
      content_type: "application/octet-stream",
      content_length: byte_size(stream),
      authorization: "UpToken " <> uptoken,
    ]

    url = (host || Qiniu.config[:up_host]) <>
          "/bput/#{ctx}/#{offset * @default_chunk_size}"
    post_with_retry(url, stream, %{headers: headers})
  end

  def mkfile(ctxs, size, opts, uptoken) do
    headers = Keyword.merge(opts[:headers] || [], [
      content_type: "text/plain",
      content_length: byte_size(ctxs),
      authorization: "UpToken " <> uptoken,
    ])

    opts_string = Keyword.take(opts, [:key, :mimeType])
      |> Enum.reduce("", fn({k, v}, acc) -> acc <> "/#{k}/#{Base.encode64(v)}" end)

    url = Qiniu.config[:up_host] <> "/mkfile/#{size}#{opts_string}"
    post_with_retry(url, ctxs, %{headers: headers})
  end

  def post_with_retry(url, body, headers, retry_limit \\ 1)
  def post_with_retry(url, body, headers, retry_limit) when retry_limit > 0 do
    try do
      Qiniu.HTTP.post(url, body, headers)
    rescue
      e in HTTPoison.Error ->
        if e.reason == :timeout do
          :timer.sleep(:timer.seconds(1))
          post_with_retry(url, body, headers, retry_limit - 1)
        end
    end
  end
  def post_with_retry(url, body, headers, _retry_limit) do
    Qiniu.HTTP.post(url, body, headers)
  end
end
