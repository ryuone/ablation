defmodule Spec.Keywordlist do
  def new(args) do
    Keyword.new args
  end
  def get(kwlist, k) do
    Keyword.get kwlist, k
  end
  def put(kwlist, k, v) do
    Keyword.put kwlist, k, v
  end
  def keys(kwlist) do
    Keyword.keys kwlist
  end
  def values(kwlist) do
    Keyword.values kwlist
  end
end
