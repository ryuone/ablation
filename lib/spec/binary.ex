defmodule Spec.Binary do
  def bin1 do
    <<65, 66, 97, 98>>
  end
  def bin2 do
    <<3 :: size(2), 5 :: size(4), 1 :: size(2)>>
  end
  def bin_match(bin, n) do
    <<_hello::binary-size(n), rest::binary>> = bin
    rest
  end
end

