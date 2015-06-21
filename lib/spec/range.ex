defmodule Spec.Range do
  @doc """
  return 3..12 in Range
  """
  def from_3_to_12 do
    range = 1..10
    Enum.map range, &(&1 + 2)
  end
end
