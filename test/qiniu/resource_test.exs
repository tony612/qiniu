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

  test "copy" do
    with_mock Auth, [access_token: fn("http://rs.qiniu.com/copy/Yjpr/YjE6azE=", "") -> "access_token" end] do
      with_mock HTTP, [post: fn("http://rs.qiniu.com/copy/Yjpr/YjE6azE=", "", headers: [Authorization: "QBox access_token"]) -> "response" end] do
        assert Qiniu.Resource.copy("b:k", "b1:k1") == "response"
      end
    end
  end

  test "move" do
    with_mock Auth, [access_token: fn("http://rs.qiniu.com/move/Yjpr/YjE6azE=", "") -> "access_token" end] do
      with_mock HTTP, [post: fn("http://rs.qiniu.com/move/Yjpr/YjE6azE=", "", headers: [Authorization: "QBox access_token"]) -> "response" end] do
        assert Qiniu.Resource.move("b:k", "b1:k1") == "response"
      end
    end
  end

  test "delete" do
    with_mock Auth, [access_token: fn("http://rs.qiniu.com/delete/Yjpr", "") -> "access_token" end] do
      with_mock HTTP, [post: fn("http://rs.qiniu.com/delete/Yjpr", "", headers: [Authorization: "QBox access_token"]) -> "response" end] do
        assert Qiniu.Resource.delete("b:k") == "response"
      end
    end
  end
end
