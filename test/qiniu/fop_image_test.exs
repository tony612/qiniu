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
end
