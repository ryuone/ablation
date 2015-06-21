defmodule Spec.Tuple do
  def normal do
    {1,2}
  end
  def tuple_with_ok do
    {:ok, {:name, :"elixir"}}
  end
  def tuple_with_error do
    {:error, :enoent}
  end
  def tuple_with_status do
    {:ok, 42, "next"}
  end
end
