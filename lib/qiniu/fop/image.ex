defmodule Qiniu.Fop.Image do
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
  Add watermark to image. There're two kinds of watermarks. See

  Refer to http://developer.qiniu.com/docs/v6/api/reference/fop/image/watermark.html

  ## Fields

    * type - `:image` or `:text`
    * image_url - URL of the image to add watermark to
    * watermark_url - image url of the watermark

  ## Options

  For image type:
    * `:dissolve` - value for transparent, 1-100
    * `:gravity` - default is SouthEast
    * `:dx` - default is 10
    * `:dy` - default is 10

  For text type:
    * `:font`
    * `:font_size`
    * `:fill`
    * `:dissolve`
    * `:gravity`
    * `:dx`
    * `:dy`
  """
  def watermark(type, image_url, watermark_url, opts \\ [])
  def watermark(:image, image_url, watermark_url, opts) do
    valid_opts = Keyword.take(opts, [:dissolve, :gravity, :dx, :dy])
    params = Enum.map_join(valid_opts, "/", fn {k, v} -> "#{k}/#{v}" end)
    params = "?watermark/1/image/#{Base.url_encode64(watermark_url)}/" <> params
    HTTP.get image_url <> params
  end

  def watermark(:text, image_url, text, opts) do
    valid_opts = Keyword.take(opts, [:font, :font_size, :fill, :dissolve, :gravity, :dx, :dy])
    params = Enum.map_join(valid_opts, "/", fn {k, v} ->
      encoded_v = if k == :font || k == :fill, do: Base.url_encode64(v), else: v
      "#{k}/#{encoded_v}"
    end)
    params = "?watermark/2/text/#{Base.url_encode64(text)}/" <> params
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
