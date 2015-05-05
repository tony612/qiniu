defmodule Qiniu.Utils do
  @moduledoc """
  Utils for Qiniu package
  """

  @doc """
  Calculate deadline with expires_in(seconds)
  """
  def calculate_deadline(expires_in) when is_integer(expires_in) and expires_in > 0  do
    current_seconds + expires_in
  end

  defp current_seconds do
    {mega, sec, _} = :erlang.now
    mega * 1_000_000 + sec
  end
end
