defmodule QiniuTest do
  use ExUnit.Case

  test "default config" do
    assert Qiniu.config[:up_host] == "http://up.qiniu.com"
  end

  test "override config" do
    assert Qiniu.config[:access_key] == "key"
  end
end
