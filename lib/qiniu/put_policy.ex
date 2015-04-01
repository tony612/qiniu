defmodule Qiniu.PutPolicy do
  defstruct scope:                 "scope",
            save_key:              "saveKey",
            end_user:              "endUser",
            return_url:            "returnUrl",
            return_body:           "returnBody",
            callback_url:          "callbackUrl",
            callback_host:         "callbackHost",
            callback_body:         "callbackBody",
            callback_body_type:    "callbackBodyType",
            persistent_ops:        "persistentOps",
            persistent_notify_url: "persistentNotifyUrl",
            persistent_pipeline:   "persistentPipeline",

            deadline:              "deadline",
            insert_only:           "insertOnly",
            fsize_limit:           "fsizeLimit",
            callback_fetch_key:    "callbackFetchKey",
            detect_mime:           "detectMime",
            mime_limit:            "mimeLimit"

  def to_json(%Qiniu.PutPolicy{} = policy) do
    policy
      |> Map.from_struct
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.into(%{})
      |> Poison.encode!
  end

  def encoded_json(%Qiniu.PutPolicy{} = policy) do
    policy |> to_json |> Base.url_encode64
  end
end
