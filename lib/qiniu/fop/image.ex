defmodule Qiniu.Fog.Image do
  alias Qiniu.HTTP

  @doc """
  Get basic information of a image, including format, size, color model

  ## Fields

    * `url` - URL of the image, like http://qiniuphotos.qiniudn.com/gogopher.jpg
  """
  def info(url) do
    HTTP.get(url <> "?imageInfo")
  end

  @doc """
  Get EXIF(EXchangeable Image File Format) of a image

  See `info/1` for the arguments
  """
  def exif(url) do
    HTTP.get(url <> "?exif")
  end

  @doc """
  Add watermark to image
  """
  def watermark(:image, image_url, watermark_url, opts) do
    type = 1
    valid_opts = Keyword.take(opts, [:dissolve, :gravity, :dx, :dy])
    params = Enum.map_join(valid_opts, "/", fn {k, v} -> "#{k}/#{v}" end)
    params = "?watermark/1/image/#{Base.url_encode64(watermark_url)}/" <> params
    HTTP.get image_url <> params
  end

  @doc """
  Get average hue of the image

  See `info/1` for the arguments
  """
  def avg_hue(url) do
    HTTP.get(url <> "?imageAve")
  end

end
