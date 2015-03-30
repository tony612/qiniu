defmodule Qiniu.AuthTest do
  use ExUnit.Case

  alias Qiniu.Auth

  test "generate_uptoken" do
    policy = %{__struct__: Qiniu.PutPolicy, scope: "scope"}
    assert Auth.generate_uptoken(policy) == "key:Bh5vAwrX2OI9syOKWXhheEm7OMw=:eyJzY29wZSI6InNjb3BlIn0="
  end

  test "hex_digest" do
    assert Auth.hex_digest("secret", "data") == "mBjjMGulrCZ7XyZ5_kq9N-bNe1Q="
  end

end
