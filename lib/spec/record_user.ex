require Record

defmodule Spec.RecordUser do
  @type user :: record(:user, name: String.t, status: atom)
  Record.defrecord :user, [name: "ryuone", status: :ok]

  def new do
    user
  end

  def new(s = :not_ok) do
    user status: s
  end
end
