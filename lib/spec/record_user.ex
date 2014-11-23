require Record

defmodule Spec.RecordUser do
  Record.defrecord :user, [name: "ryuone", status: :ok]
end
