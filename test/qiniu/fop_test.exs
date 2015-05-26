defmodule Qiniu.FopTest do
  use ExUnit.Case

  alias Qiniu.Fop
  alias Qiniu.HTTP

  import Mock

  test "qrcode" do
    with_mock HTTP, [:passthrough], [get: fn("http://f.o?qrcode/0/level/L") ->"response" end] do
      assert Fop.qrcode("http://f.o") == "response"
    end

    with_mock HTTP, [:passthrough], [get: fn("http://f.o?qrcode/0/level/H") ->"response" end] do
      assert Fop.qrcode("http://f.o", "H") == "response"
    end
  end
end
