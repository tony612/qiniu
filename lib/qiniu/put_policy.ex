defmodule Qiniu.PutPolicy do
  @moduledoc """
  PutPolicy struct for uploading. And you have to specify right `scope`
  and `deadline` to let uploading work.

  See http://developer.qiniu.com/docs/v6/api/reference/security/put-policy.html
  """

  alias __MODULE__

  defstruct scope:                 nil,
            deadline:              nil,
            insert_only:           nil,
            save_key:              nil,
            end_user:              nil,
            return_url:            nil,
            return_body:           nil,
            callback_url:          nil,
            callback_host:         nil,
            callback_body:         nil,
            callback_body_type:    nil,
            callback_fetch_key:    nil,
            persistent_ops:        nil,
            persistent_notify_url: nil,
            persistent_pipeline:   nil,
            fsize_limit:           nil,
            detect_mime:           nil,
            mime_limit:            nil,
            checksum:              nil

  @type t :: %PutPolicy{
            scope:                 String.t,
            deadline:              integer,
            insert_only:           integer | nil,
            save_key:              String.t | nil,
            end_user:              String.t | nil,
            return_url:            String.t | nil,
            return_body:           String.t | nil,
            callback_url:          String.t | nil,
            callback_host:         String.t | nil,
            callback_body:         String.t | nil,
            callback_body_type:    String.t | nil,
            callback_fetch_key:    integer | nil,
            persistent_ops:        String.t | nil,
            persistent_notify_url: String.t | nil,
            persistent_pipeline:   String.t | nil,
            fsize_limit:           integer | nil,
            detect_mime:           integer | nil,
            mime_limit:            String.t | nil,
            checksum:              String.t | nil
            }


  @doc """
  Change put_policy to json string expect the `nil` values.

  ## Examples

      iex> policy = %Qiniu.PutPolicy{scope: "scope", deadline: 1427990400}
      iex> Qiniu.PutPolicy.to_json(policy)
      ~s({"scope":"scope","deadline":1427990400})
  """
  @spec to_json(PutPolicy.t) :: String.t
  def to_json(%PutPolicy{} = policy) do
    policy
      |> Map.from_struct
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.into(%{})
      |> Poison.encode!
  end

  @doc """
  Change put_policy to json string and encode it with url safe

  ## Examples

      iex> policy = %Qiniu.PutPolicy{scope: "scope"}
      iex> Qiniu.PutPolicy.encoded_json(policy)
      "eyJzY29wZSI6InNjb3BlIn0="
  """
  @spec encoded_json(PutPolicy.t) :: String.t
  def encoded_json(%PutPolicy{} = policy) do
    policy |> to_json |> Base.url_encode64
  end
end
