defmodule Qiniu.ResourceTest do
  use ExUnit.Case

  alias Qiniu.Resource
  alias Qiniu.HTTP
  alias Qiniu.Auth

  import Mock

  test "stat" do
    with_mock Auth, [access_token: fn("http://rs.qiniu.com/stat/Yjpr", "") -> "access_token" end] do
      with_mock HTTP, [post: fn("http://rs.qiniu.com/stat/Yjpr", "", headers: [Authorization: "QBox access_token"]) -> "response" end] do
        assert Qiniu.Resource.stat("b:k") == "response"
      end
    end
  end
end
