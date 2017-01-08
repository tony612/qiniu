defmodule Qiniu.Utils do
  @moduledoc """
  Utils for Qiniu package
  """

  @doc """
  Calculate deadline with expires_in(seconds)
  """
  def calculate_deadline(expires_in) when is_integer(expires_in) and expires_in > 0  do
    current_seconds() + expires_in
  end

  defp current_seconds do
    {mega, sec, _} = current_time()

    mega * 1_000_000 + sec
  end

  defp current_time do
    :os.timestamp
  end

  @doc """
  ## Examples

      iex> Qiniu.Utils.camelize("return_body")
      "returnBody"
  """
  def camelize(string) do
    string |> to_string |> Macro.camelize |> uncapitalize
  end

  defp uncapitalize(str) do
    {first, rest} = String.split_at(str, 1)
    String.downcase(first) <> rest
  end
end
