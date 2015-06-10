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

  test "list with no options" do
    with_mock HTTP, [auth_post: fn("http://rsf.qbox.me/list?bucket=bucket", "") -> "response" end] do
      assert Resource.list("bucket") == "response"
    end
  end

  test "list with options" do
    with_mock HTTP, [auth_post: fn("http://rsf.qbox.me/list?bucket=bucket&limit=10&prefix=foo&delimiter=/&marker=m", "") -> "response" end] do
      assert Resource.list("bucket", limit: 10, prefix: "foo", delimiter: "/", marker: "m") == "response"
    end
  end

  test "fetch" do
    with_mock HTTP, [auth_post: fn("http://iovip.qbox.me/fetch/aHR0cDovL2ltYWdlLnVybA==/to/YnVja2V0OmtleQ==", "") -> "response" end] do
      assert Resource.fetch("http://image.url", "bucket:key") == "response"
    end
  end

  test "prefetch" do
    with_mock HTTP, [auth_post: fn("http://iovip.qbox.me/prefetch/YnVja2V0OmtleQ==", "") -> "response" end] do
      assert Resource.prefetch("bucket:key") == "response"
    end
  end

end
