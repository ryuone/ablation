defmodule SpecNumberTest do
  use ExUnit.Case

  test "(decimal)1_000_000 is a number" do
    assert Spec.Number.underscore_number === 1000000
  end
  test "(hexadecimal)0x1f is a number" do
    assert Spec.Number.hex === 31
  end
  test "(octal)0o765 is a number" do
    assert Spec.Number.octal === 501
  end
  test "(binary)0b1010 is a number" do
    assert Spec.Number.binary === 10
  end
  test "(floating)0.314e1 is a number" do
    assert Spec.Number.float1 === 3.14
  end
  test "(floating)314.0e-2 is a number" do
    assert Spec.Number.float2 === 3.14
  end
end
