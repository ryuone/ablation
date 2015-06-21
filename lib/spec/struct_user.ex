defmodule Spec do
  defmodule StructUser do
    @type t :: %StructUser{name: String.t, status: atom}
    defstruct name: "", status: :dont_know

    def new do
      %StructUser{}
    end
    def new name do
      %StructUser{name: name}
    end

    def new name, status do
      %StructUser{name: name, status: status}
    end

    def update struct, status: status do
      %{struct | status: status}
    end
  end
end
