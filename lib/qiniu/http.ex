defmodule Qiniu.HTTP do
  @moduledoc false

  def post(url, body, opts \\ []) do
    headers = Keyword.merge(opts[:headers] || [], [
      accept: "application/json",
      connection: "close",
      user_agent: Qiniu.config[:user_agent],
    ])

    response = HTTPoison.post! url, body, headers

    if opts[:parse] do
      %{response | body: Poison.decode!(response.body)}
    else
      response
    end
  end
end
