defmodule SpecRecordTest do

  defmodule SpecRecord do
    use ExUnit.Case

    test "Create record" do
      assert {:user, "ryuone", :ok} === Spec.RecordUser.new
    end

    test "Create record with argument" do
      assert {:user, "ryuone", :not_ok} === Spec.RecordUser.new :not_ok
    end

    test "Get zero position value via elem function" do
      assert :user === Spec.RecordUser.new |> elem 0
    end

    test "Get second position value via elem function" do
      assert :ok === Spec.RecordUser.new |> elem 2
    end
  end
end
