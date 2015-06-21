defmodule Spec.Number do
  @doc """
  return 1_000_000
  """
  def underscore_number do
    1_000_000
  end

  @doc """
  return 0x1f ub Hex
  """
  def hex do
    0x1f
  end

  @doc """
  return 0o765 in Octal
  """
  def octal do
    0o765
  end

  @doc """
  return 0b1010 in Binary
  """
  def binary do
    0b1010
  end

  @doc """
  return 0.314e1 in Float
  """
  def float1 do
    0.314e1
  end

  @doc """
  return 314.0e-2 in Float
  """
  def float2 do
    314.0e-2
  end
end
