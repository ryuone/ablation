defprotocol Spec.Blank do
  @doc "Returns true if data is considered blank/empty"
  def blank?(data)
end

defimpl Spec.Blank, for: Spec.StructUser do
  def blank?(%Spec.StructUser{name: ""} = _user) do
    true
  end
  def blank?(%Spec.StructUser{name: _} = _user) do
    false
  end
end