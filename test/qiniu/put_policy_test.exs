defmodule Qiniu.PutPolicyTest do
  use ExUnit.Case

  doctest Qiniu.PutPolicy, except: [build: 1, build: 2, build: 3]

  import Mock

  test "build/1" do
    with_mock Qiniu.Utils, [calculate_deadline: fn (3600)-> 1428236535 end] do
      assert Qiniu.PutPolicy.build("scope") ==
             %Qiniu.PutPolicy{scope: "scope", deadline: 1428232935 + 3600}
    end
  end

  test "build/2 with expires_in" do
    with_mock Qiniu.Utils, [calculate_deadline: fn (4000)-> 1428236935 end] do
      assert Qiniu.PutPolicy.build("scope", 4000) ==
             %Qiniu.PutPolicy{scope: "scope", deadline: 1428232935 + 4000}
    end
  end

  test "build/2 with options" do
    with_mock Qiniu.Utils, [calculate_deadline: fn (3600)-> 1428236535 end] do
      assert Qiniu.PutPolicy.build("scope", insert_only: 1) ==
             %Qiniu.PutPolicy{scope: "scope", deadline: 1428232935 + 3600,
                              insert_only: 1}
    end
  end

  test "build/3" do
    with_mock Qiniu.Utils, [calculate_deadline: fn (4000)-> 1428236935 end] do
      assert Qiniu.PutPolicy.build("scope", 4000, insert_only: 1) ==
             %Qiniu.PutPolicy{scope: "scope", deadline: 1428232935 + 4000,
                              insert_only: 1}
    end
  end
end
