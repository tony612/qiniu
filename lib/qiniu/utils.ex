defmodule Qiniu.Utils do
  @moduledoc """
  Utils for Qiniu package
  """

  @doc """
  Returns the value of time as an integer number of seconds since the Epoch.
  """
  def current_seconds do
    {mega, sec, micro} = :erlang.now
    div(mega * 1_000_000 * 1_000_000 + sec * 1_000_000 + micro, 1_000_000)
  end
end
