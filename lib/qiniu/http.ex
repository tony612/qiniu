defmodule Qiniu.HTTP do
  @moduledoc false

  def post(url, body, opts \\ []) do
    request(:post, url, body, opts)
  end

  def get(url, opts \\ []) do
    request(:get, url, opts)
  end

  defp request(method, url, opts) do
    request(method, url, "", opts)
  end
  defp request(method, url, body, opts) do
    headers = Keyword.merge(opts[:headers] || [], [
      accept: "application/json",
      connection: "close",
      user_agent: Qiniu.config[:user_agent],
    ])

    response = case method do
      :get -> HTTPoison.get! url, headers
      :post -> HTTPoison.post! url, body, headers
    end

    if opts[:parse] do
      %{response | body: Poison.decode!(response.body)}
    else
      response
    end
  end
end
