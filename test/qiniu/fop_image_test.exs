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

  test "watermark for image type with four options" do
    with_mock HTTP, [get: fn("http://img.url?watermark/1/image/aHR0cDovL3dhdGVybWFyay51cmw=/dissolve/50/gravity/Center/dx/20/dy/20") -> "response" end] do
      assert Image.watermark(:image, "http://img.url", "http://watermark.url", dissolve: 50, gravity: "Center", dx: 20, dy: 20)
    end
  end

  test "watermark for image type with one options" do
    with_mock HTTP, [get: fn("http://img.url?watermark/1/image/aHR0cDovL3dhdGVybWFyay51cmw=/gravity/Center") -> "response" end] do
      assert Image.watermark(:image, "http://img.url", "http://watermark.url", gravity: "Center")
    end
  end

  test "watermark for text type" do
    with_mock HTTP, [get: fn("http://img.url?watermark/2/text/d2F0ZXJtYXJr/") -> "response" end] do
      assert Image.watermark(:text, "http://img.url", "watermark")
    end
  end

  test "watermark for text type with options" do
    with_mock HTTP, [get: fn("http://img.url?watermark/2/text/d2F0ZXJtYXJr/font/5a6L5L2T/fill/d2hpdGU=/dissolve/50/dy/100") -> "response" end] do
      assert Image.watermark(:text, "http://img.url", "watermark", font: "宋体", fill: "white", dissolve: 50, dy: 100)
    end
  end

  test "avg_hue" do
    with_mock HTTP, [get: fn("http://img.url?imageAve") ->"response" end] do
      assert Image.avg_hue("http://img.url") == "response"
    end
  end
end
