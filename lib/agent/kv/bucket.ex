defmodule Agent.KV.Bucket do
  use GenServer

  @type on_start :: {:ok, pid} | {:error, {:already_started, pid} | term}

  @doc """
  Start a new bucket
  """
  @spec start_link() :: on_start
  def start_link() do
    Agent.start_link(fn -> HashDict.new end)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  @spec get(pid, any) :: any
  def get(bucket, key) do
    Agent.get(bucket, &HashDict.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  @spec put(pid, any, any) :: :ok
  def put(bucket, key, value) do
    Agent.update(bucket, &HashDict.put(&1, key, value))
  end

  @doc """
  Deletes `key` from `bucket`.

  Returns the current value of `key`, if `key` exists.
  """
  @spec delete(pid, any) :: any
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &HashDict.pop(&1, key))
  end

  @doc """
  Stop `bucket`.
  """
  @spec stop(pid) :: :ok
  def stop(bucket) do
    Agent.stop(bucket)
  end
end
