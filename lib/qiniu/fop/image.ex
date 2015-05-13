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

  ## Fields

    * `url` - URL of the image, like http://qiniuphotos.qiniudn.com/gogopher.jpg
  """
  def exif(url) do
    HTTP.get(url <> "?exif")
  end
end
