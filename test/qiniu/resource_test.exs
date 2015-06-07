defmodule Qiniu.ResourceTest do
  use ExUnit.Case

  alias Qiniu.Resource
  alias Qiniu.HTTP

  import Mock

  test "stat" do
    with_mock HTTP, [auth_post: fn("http://rs.qiniu.com/stat/Yjpr", "") -> "response" end] do
      assert Resource.stat("b:k") == "response"
    end
  end

  test "copy" do
    with_mock HTTP, [auth_post: fn("http://rs.qiniu.com/copy/Yjpr/YjE6azE=", "") -> "response" end] do
      assert Resource.copy("b:k", "b1:k1") == "response"
    end
  end

  test "move" do
    with_mock HTTP, [auth_post: fn("http://rs.qiniu.com/move/Yjpr/YjE6azE=", "") -> "response" end] do
      assert Resource.move("b:k", "b1:k1") == "response"
    end
  end

  test "delete" do
    with_mock HTTP, [auth_post: fn("http://rs.qiniu.com/delete/Yjpr", "") -> "response" end] do
      assert Resource.delete("b:k") == "response"
    end
  end

  test "batch" do
    with_mock HTTP, [auth_post: fn("http://rs.qiniu.com?op=/stat/Yjpr&op=/copy/Yjpr/YjE6azE=&op=/move/Yjpr/YjE6azE=&op=/delete/Yjpr", "") -> "response" end] do
      assert Resource.batch([[:stat, "b:k"], [:copy, "b:k", "b1:k1"], [:move, "b:k", "b1:k1"], [:delete, "b:k"]]) == "response"
    end
  end
end
