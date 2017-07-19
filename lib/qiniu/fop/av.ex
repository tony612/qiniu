defmodule Qiniu.Fop.AV do
  @moduledoc """
  Audio-visual processing
  https://developer.qiniu.com/dora/manual/3685/directions-for-use-av
  """
  alias Qiniu.HTTP

  def avthumb(bucket_name, key, opts \\ []) do
    query_opts = opts |> Keyword.take([:notifyURL, :pipeline]) |> Enum.into(%{})
    fog_opts = opts |> Keyword.delete(:notifyURL) |> Keyword.delete(:pipeline)

    body =
      %{
        bucket: bucket_name,
        key: key,
        fops: trans_fops(fog_opts),
      }
      |> Map.merge(query_opts)
      |> URI.encode_query

    HTTP.auth_post("#{Qiniu.config[:api_host]}/pfop/", body)
  end


  @doc """
   iex> Qiniu.Fop.AV.trans_fops([])
   ""
   iex> Qiniu.Fop.AV.trans_fops([avthumb: "mp4", s: "640x360", saveas: "bucket1:test.mp4"])
   "/avthumb/mp4/s/640x360|saveas/YnVja2V0MTp0ZXN0Lm1wNA=="
  """
  def trans_fops(opts \\ []) do
    opts
    |> Enum.reduce("", fn({arg, value}, acc) ->
      case trans_fop(arg, value) do
        "|" <> _ = next_step -> "#{acc}#{next_step}"
        regular_fop  -> "#{acc}/#{regular_fop}"
      end
    end)
  end
  defp trans_fop(:saveas, bucket_name_key) do
    "|saveas/" <> Base.url_encode64(bucket_name_key)
  end
  defp trans_fop(arg, value) do
    "#{arg}/#{value}"
  end
end
