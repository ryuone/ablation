defmodule Spec.Hashset do
  def new do
    HashSet.new
  end
  def to_list hs do
    hs |> HashSet.to_list
  end
  def union hs1, hs2 do
    HashSet.union hs1, hs2
  end
  def member? hs, v do
    hs |> HashSet.member?(v)
  end
  def difference hs1, hs2 do
    HashSet.difference hs1, hs2
  end
  def intersection hs1, hs2 do
    HashSet.intersection hs1, hs2
  end
end

