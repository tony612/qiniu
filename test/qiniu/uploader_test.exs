defmodule Qiniu.UploaderTest do
  use ExUnit.Case

  import Mock

  alias Qiniu.{HTTP, Uploader, PutPolicy}

  test "upload/2 uses put_policy to upload" do
    put_policy = %PutPolicy{scope: "scope"}
    data = {:multipart, [{:file, "~/cool.jpg"}, {"token", "key:Bh5vAwrX2OI9syOKWXhheEm7OMw=:eyJzY29wZSI6InNjb3BlIn0="}]}
    with_mock HTTP, [:passthrough], [post: fn("http://up.qiniu.com", ^data) ->"response" end] do
      assert Uploader.upload(put_policy, "~/cool.jpg") == "response"
    end
  end

  test "upload/2 uses uptoken to upload" do
    data = {:multipart, [{:file, "~/cool.jpg"}, {"token", "uptoken"}]}
    with_mock HTTP, [:passthrough], [post: fn("http://up.qiniu.com", ^data) ->"response" end] do
      assert Uploader.upload("uptoken", "~/cool.jpg") == "response"
    end
  end

  test "upload/2 support option :key" do
    data = {:multipart, [{"key", "abc.jpg"}, {:file, "~/cool.jpg"}, {"token", "uptoken"}]}
    with_mock HTTP, [:passthrough], [post: fn("http://up.qiniu.com", ^data) ->"response" end] do
      assert Uploader.upload("uptoken", "~/cool.jpg", key: "abc.jpg") == "response"
    end
  end

  test "upload/2 support option :crc32" do
    data = {:multipart, [{"crc32", "1271261733"}, {:file, "~/cool.jpg"}, {"token", "uptoken"}]}
    with_mock HTTP, [:passthrough], [post: fn("http://up.qiniu.com", ^data) ->"response" end] do
      assert Uploader.upload("uptoken", "~/cool.jpg", crc32: 1271261733) == "response"
    end
  end

end
