defmodule Qiniu.AuthTest do
  use ExUnit.Case

  alias Qiniu.Auth

  import Mock

  test "generate_uptoken" do
    policy = %{__struct__: Qiniu.PutPolicy, scope: "scope"}
    assert Auth.generate_uptoken(policy) == "key:Bh5vAwrX2OI9syOKWXhheEm7OMw=:eyJzY29wZSI6InNjb3BlIn0="
  end

  test "authorize_download_url/2" do
    with_mock Qiniu.Utils, [calculate_deadline: fn (3600)-> 1451491200 end] do
      url = "http://my-bucket.qiniudn.com/sunflower.jpg"
      result = "#{url}?e=1451491200&token=key:x8KR9b4GU1Py-VVFhnFjpW3MDv8="
      assert Auth.authorize_download_url(url, 3600) == result
    end
  end

  test "authorize_download_url/3" do
    with_mock Qiniu.Utils, [calculate_deadline: fn (3600)-> 1451491200 end] do
      host = "http://my-bucket.qiniudn.com"
      key = "sunflower.jpg"
      url = host <> "/" <> key
      result = "#{url}?e=1451491200&token=key:x8KR9b4GU1Py-VVFhnFjpW3MDv8="
      assert Auth.authorize_download_url(host, key, 3600) == result
    end
  end

  test "access_token/1" do
    url = "http://rs.qiniu.com/move/bmV3ZG9jczpmaW5kX21hbi50eHQ=/bmV3ZG9jczpmaW5kLm1hbi50eHQ="
    assert Auth.access_token(url) == "key:KcvqMmLJo0Xykcpj9k6loD6oHD4="
  end

  test "access_token/1 builds with query" do
    url = "http://rs.qiniu.com/move/bmV3ZG9jczpmaW5kX21hbi50eHQ=/bmV3ZG9jczpmaW5kLm1hbi50eHQ=?foo=bar"
    assert Auth.access_token(url) == "key:sGYENctb3-sgC063ABDZhQO1IAM="
  end

  test "access_token/2" do
    url = "http://rs.qiniu.com/move/bmV3ZG9jczpmaW5kX21hbi50eHQ=/bmV3ZG9jczpmaW5kLm1hbi50eHQ="
    assert Auth.access_token(url, "foo") == "key:ORUvoSE8ZMmXMRHMs5JvayEZ4dE="
  end

  test "hex_digest" do
    assert Auth.hex_digest("secret", "data") == "mBjjMGulrCZ7XyZ5_kq9N-bNe1Q="
  end

end
