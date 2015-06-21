defmodule Spec.Map do
  def new do
    %{ "Tokyo" => "東京", "Osaka" => "大阪" }
  end
  def new_atom_key do
    %{ :tokyo => "東京", :osaka => "大阪" }
  end
  def new_list_key do
    %{ [name: "A"] => "Name A", [name: "B"] => "Name B" }
  end
  def update_tokyo base, v do
    %{base | :tokyo => v}
  end
  def update base, k, v do
    Map.update! base, k, fn(_val) -> v end
  end
end

