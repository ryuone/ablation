defmodule ComprehensionTest do
  use ExUnit.Case

  test "Simple for" do
    assert [1, 4, 9, 16] === for n <- [1, 2, 3, 4], do: n * n
    assert [4, 9, 16, 25] === for n <- 2..5, do: n * n
  end
  test "Simple for with pattern match" do
    values = [good: 1, good: 2, bad: 3, good: 4]
    assert [1,4,16] === for {:good, n} <- values, do: n * n
  end
  test "Simple for with filter" do
    values = [good: 1, good: 2, bad: 3, good: 4]
    assert [1,4,16] === for {key, n} <- values, key == :good, do: n * n
  end
  test "Simple for with Integer.is_odd" do
    require Integer
    assert [1,9] === for n <- 1..4,Integer.is_odd(n), do: n * n
  end
  test "Get file" do
    file = for dir <- ['.'],
        file <- File.ls!(dir),
        path = Path.join(dir, file),
        File.regular?(path) do
      path
    end |> Enum.sort |> List.first
    assert "./.gitignore" === file
  end
  test "Comprehension with Bitstring" do
    pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>
    assert [{213,45,132},{64,76,32},{76,0,0},{234,32,15}] === for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b}
  end
  test "Comprehension with into" do
    assert "helloworld" === for <<c <- " hello world ">>, c != ?\s, into: "", do: <<c>>
  end
  test "Comprehension with into List" do
    box = [100,200]
    assert [100, 200, 2, 3, 4, 5, 6] === for n <- [1,2,3,4,5], into: box, do: n + 1
  end
  test "Comprehension with into Map" do
    result = for {key,value} <- [app: "elixir", version: "1.1.0-dev"],
        into: %{} do
      {key, value: value}
    end
    assert result === %{app: [value: "elixir"], version: [value: "1.1.0-dev"]}
  end
end