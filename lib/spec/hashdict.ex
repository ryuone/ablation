defmodule Spec.Hashdict do
  def new do
    HashDict.new
  end
  def size hd do
    hd |> HashDict.size
  end
  def values hd do
    hd |> HashDict.values
  end
  def keys hd do
    hd |> HashDict.keys
  end
  def put hd, k, v do
    hd |> HashDict.put(k, v)
  end
  def merge hd1, hd2 do
    HashDict.merge hd1, hd2
  end
end

