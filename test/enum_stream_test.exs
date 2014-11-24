defmodule EnumStreamTest do
  use ExUnit.Case

  test "Enum.map(list)" do
    assert [2,4,6] === Enum.map([1, 2, 3], fn x -> x * 2 end)
  end
  test "Enum.map(map)" do
    assert [2,12] === Enum.map(%{1 => 2, 3 => 4}, fn {k, v} -> k * v end)
  end
  test "Enum.map(range)" do
    assert [2,4,6] === Enum.map(1..3, fn x -> x * 2 end)
  end
  test "Enum.reduce" do
    assert 6 === Enum.reduce(1..3, 0, &+/2)
  end
  test "Stream.map with Stream.filter" do
    odd? = &(rem(&1, 2) !== 0)
    assert 7500000000 === 1..100_000 |> Stream.map(&(&1 * 3)) |> Stream.filter(odd?) |> Enum.sum
  end
  test "Stream.map with Enum.take" do
    assert [2,3,4,5,6] === Stream.map(1..10_000_000, &(&1+1)) |> Enum.take(5)
  end
end
