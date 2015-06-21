defmodule Spec.List do

  def append(lhs, rhs) do
    lhs ++ rhs
  end

  def remove(lhs, rhs) do
    lhs -- rhs
  end
end
