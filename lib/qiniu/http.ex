defmodule Qiniu.HTTP do
  @moduledoc false

  def post(url, body) do
    headers = [
      accept: 'application/json',
      connection: "close",
      user_agent: Qiniu.config[:user_agent],
    ]

    HTTPoison.post! url, body, headers
  end
end
