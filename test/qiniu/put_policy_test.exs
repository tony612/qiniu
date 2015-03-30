defmodule Qiniu.PutPolicyTest do
  use ExUnit.Case

  alias Qiniu.PutPolicy

  test "to_json returns json string with nil" do
    policy = struct(PutPolicy, scope: nil)
    str = PutPolicy.to_json(policy)
    assert !String.contains?(str, "scope")
    assert String.contains?(str, "{\"save_key\":\"saveKey\",")
  end
end
