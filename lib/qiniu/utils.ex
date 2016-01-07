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
    {mega, sec, _} = current_time

    mega * 1_000_000 + sec
  end

  defp current_time do
    case List.to_integer(:erlang.system_info(:otp_release)) do
      18 ->
        :os.timestamp
      true ->
        :erlang.now
    end
  end
end
