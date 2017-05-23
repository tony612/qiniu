defmodule Qiniu.HTTPTest do
  use ExUnit.Case

  import Mock

  defmodule Response do
    defstruct [:body]
  end

  alias Qiniu.HTTP

  test "parsing json body" do
    url = "http://up.qiniu.com"
    headers = [
      accept: "application/json",
      connection: "close",
      user_agent: Qiniu.config[:user_agent],
    ]
    body = "body"
    resp = %Response{body: "{\"status\":\"ok\"}"}
    with_mock HTTPoison, [:passthrough], [post!: fn(^url, ^body, ^headers) -> resp end] do
      assert HTTP.post(url, body) == %Response{body: %{"status" => "ok"}}
    end
  end

  test "returns response directly" do
    url = "http://up.qiniu.com"
    headers = [
      accept: "application/json",
      connection: "close",
      user_agent: Qiniu.config[:user_agent],
    ]
    body = "body"
    resp = %Response{body: "response"}
    with_mock HTTPoison, [:passthrough], [post!: fn(^url, ^body, ^headers) -> resp end] do
      assert HTTP.post(url, body) == %Response{body: "response"}
    end
  end
end
