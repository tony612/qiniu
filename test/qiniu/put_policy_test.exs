defmodule Qiniu.PutPolicyTest do
  use ExUnit.Case

  alias Qiniu.PutPolicy

  test "to_json returns json string with nil" do
    policy = %{__struct__: PutPolicy, scope: "scope", save_key: nil}
    assert PutPolicy.to_json(policy) == "{\"scope\":\"scope\"}"
  end

  test "encoded_json" do
    policy = %{__struct__: PutPolicy, scope: "scope"}
    assert PutPolicy.encoded_json(policy) == "eyJzY29wZSI6InNjb3BlIn0="
  end
end
