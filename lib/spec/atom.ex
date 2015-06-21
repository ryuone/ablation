defmodule Spec.Atom do
  def atom_foo do
    :foo
  end
  def atom_include_atmark do
    :me@localhost
  end
  def atom_with_spaces_double_quote do
    :"with spaces"
  end
  def atom_with_spaces_single_quote do
    :'with spaces'
  end
  def atom_inequality do
    :<>
  end
  def atom_equality do
    :===
  end
end
