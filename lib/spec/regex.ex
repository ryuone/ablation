defmodule Spec.Regex do
  @doc """
  return result of Regex
  """
  def regex_digit(arg1) do
    reg = ~r{(\d*)}i
    Regex.run reg, arg1
  end
end
