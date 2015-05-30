defmodule Qiniu.Fop.ImageTest do
  use ExUnit.Case

  alias Qiniu.Fop.Image
  alias Qiniu.HTTP

  import Mock

  test "info" do
    with_mock HTTP, [get: fn("http://img.url?imageInfo") ->"response" end] do
      assert Image.info("http://img.url") == "response"
    end
  end

  test "exif" do
    with_mock HTTP, [get: fn("http://img.url?exif") ->"response" end] do
      assert Image.exif("http://img.url") == "response"
    end
  end

  test "watermark for image type" do
    with_mock HTTP, [get: fn("http://img.url?watermark/1/image/aHR0cDovL3dhdGVybWFyay51cmw=/") -> "response" end] do
      assert Image.watermark(:image, "http://img.url", "http://watermark.url")
    end
  end

  test "watermark for text type" do
    with_mock HTTP, [get: fn("http://img.url?watermark/2/text/d2F0ZXJtYXJr/") -> "response" end] do
      assert Image.watermark(:text, "http://img.url", "watermark")
    end
  end

  test "avg_hue" do
    with_mock HTTP, [get: fn("http://img.url?imageAve") ->"response" end] do
      assert Image.avg_hue("http://img.url") == "response"
    end
  end
end
