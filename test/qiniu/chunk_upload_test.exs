defmodule Qiniu.ChunkUploadTest do
  use ExUnit.Case

  import Mock

  alias Qiniu.{HTTP, ChunkUpload, PutPolicy}

  setup do
    {:ok, scope: %PutPolicy{scope: "scope"}}
  end

  doctest ChunkUpload

  test "chunk_upload/3", put_policy do
    blocks     = ["1", "2", "3", "4"]
    stat       = {:ok, %{size: 4096, type: :regular}}
    with_mocks([
      {File,
       [:passthrough],
       [stream!: fn(_, _, _) -> blocks end,
        stat: fn(_) -> stat end]
      },
      {HTTP,
       [],
       [post:
          fn(_, _, _) ->
            %HTTPoison.Response{body: %{"ctx" => "ctx", "host" => "host"}}
          end
        ]
      },
    ]) do
      ChunkUpload.chunk_upload(put_policy[:scope], "~4.jpg")
      assert called HTTP.post("http://up.qiniu.com/mkfile/4096",
                              "ctx,ctx,ctx,ctx", :_)
    end
  end

  test "chunk_upload/3 with invalid file type", put_policy do
    blocks     = ["1", "2", "3", "4"]
    stat       = {:ok, %{size: 4096, type: :device}}
    with_mocks([
      {File,
       [:passthrough],
       [stream!: fn(_, _, _) -> blocks end,
        stat: fn(_) -> stat end]
      },
    ]) do
      res = ChunkUpload.chunk_upload(put_policy[:scope], "~4.jpg")
      assert res == {:error, "Expect a regular file, `~4.jpg` is a device"}
    end
  end

  test "chunk_upload/3 when failed to open file", put_policy do
    blocks     = ["1", "2", "3", "4"]
    stat       = {:error, :enoent}
    with_mocks([
      {File,
       [:passthrough],
       [stream!: fn(_, _, _) -> blocks end,
        stat: fn(_) -> stat end]
      },
    ]) do
      res = ChunkUpload.chunk_upload(put_policy[:scope], "~4.jpg")
      assert res == {:error, "Can not found the file `~4.jpg`"}
    end
  end

  test "chunk_upload/3 with other errors", put_policy do
    blocks     = ["1", "2", "3", "4"]
    stat       = {:error, :eacces}
    with_mocks([
      {File,
       [:passthrough],
       [stream!: fn(_, _, _) -> blocks end,
        stat: fn(_) -> stat end]
      },
    ]) do
      res = ChunkUpload.chunk_upload(put_policy[:scope], "~4.jpg")
      assert res == {:error, :eacces}
    end
  end

  test "send_block/3" do
    with_mocks([
      {HTTP,
       [],
       [post:
          fn(_, _, _) ->
            %HTTPoison.Response{body: %{"ctx" => "ctx", "host" => "host"}}
          end
        ]
      }
    ]) do
      res = ChunkUpload.send_block(["1", "2"], 1024, [], "key")
      assert res == "ctx"
    end
  end

  test "send_block/3 with error" do
    with_mocks([
      {HTTP,
       [],
       [post:
          fn(_, _, _) ->
            %HTTPoison.Response{status_code: 400}
          end
        ]
      }
    ]) do
      res = ChunkUpload.send_block(["123"], 1, [], "key")
      assert %{status_code: 400} = res
    end
  end

  test "send_chunk/5"do
    block     = ["1"]
    with_mock HTTP,
              [],
              [post: fn(_, _, _) ->
                      %HTTPoison.Response{status_code: 400}
                     end] do
      res = ChunkUpload.send_chunk(block, 1, "123", "key: value", "qiniu.com")
      assert called HTTP.post("qiniu.com/bput/123/1048576", :_, :_)
      assert %{status_code: 400} = res
    end
  end

  test "post_with_retry/4" do
    with_mock HTTP, [:passthrough], [post: fn(_, _, _) ->
                                  raise %HTTPoison.Error{reason: :timeout} end] do

      assert_raise HTTPoison.Error,
                   fn -> ChunkUpload.post_with_retry("123", "123", [], 3) end
    end
  end

  test "mkfile/4 with options" do
     with_mocks([
      {HTTP,
       [],
       [post:
          fn(_, _, _) ->
            %HTTPoison.Response{body: %{"ctx" => "ctx", "host" => "host"}}
          end
        ]
      }
    ]) do
      ChunkUpload.mkfile("123", 1024, [key: "test"], "key")
      assert called HTTP.post("http://up.qiniu.com/mkfile/1024/key/dGVzdA==", :_, :_)
    end
  end
end
