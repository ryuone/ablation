defmodule Agent.KV do
  require Logger
  use GenServer

  @type on_start :: {:ok, pid} | {:error, {:already_started, pid} | term}

  @type name :: atom | {:global, term} | {:via, module, term}
  @type server :: pid | name | {atom, node}

  @type key :: atom
  @type value :: any
  @type t :: [{key, value}]

  @doc """
  Starts the KV registory
  """
  @spec start_link() :: on_start
  def start_link() do
    opts = [] |> set_server_name
    start_link(opts)
  end
  @spec start_link(list) :: on_start
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in the KV `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  @spec lookup(any) :: {:ok, pid} | :error
  def lookup(name) do
    lookup(__MODULE__, name)
  end
  @spec lookup(server, any) :: {:ok, pid} | :error
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Looks up the bucket pid for `name` stored in the KV `server`.

  Returns `pid` if the bucket exists, `:error` otherwise.
  """
  @spec lookup!(any) :: pid | :error
  def lookup!(name) do
    {:ok, pid} = lookup(__MODULE__, name)
    pid
  end
  @spec lookup!(server, any) :: pid | :error
  def lookup!(server, name) do
    {:ok, pid} = GenServer.call(server, {:lookup, name})
    pid
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in KV `server`.
  """
  @spec create(any) :: :ok
  def create(name) do
    create(__MODULE__, name)
  end
  @spec create(server, any) :: :ok
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  @doc """
  Stops the KV `server`
  """
  @spec stop() :: term
  def stop() do
    stop(__MODULE__)
  end
  @spec stop(server) :: term
  def stop(server) do
    GenServer.call(server, :stop)
  end

  @doc """
  Get value from the specific bucket.
  """
  @spec get(any, any) :: any
  def get(name, key) do
    lookup!(name) |> Agent.KV.Bucket.get key
  end
  @spec get(server, any, any) :: any
  def get(server, name, key) do
    lookup!(server, name) |> Agent.KV.Bucket.get key
  end

  @doc """
  Get value to the specific bucket.
  """
  @spec put(any, any, any) :: :ok
  def put(name, key, value) do
    lookup!(name) |> Agent.KV.Bucket.put key, value
  end
  @spec put(server, any, any, any) :: :ok
  def put(server, name, key, value) do
    lookup!(server, name) |> Agent.KV.Bucket.put key, value
  end

  ########################
  ## Private
  ########################
  @spec set_server_name(t) :: t
  defp set_server_name(opts) do
    case opts |> List.keymember? :name, 0 do
      true -> opts
      _    -> opts |> Keyword.put_new :name, __MODULE__
    end
  end

  ########################
  ## Server Callbacks
  ########################
  def init([]) do
    Process.flag(:trap_exit, true)
    {:ok, HashDict.new}
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, HashDict.fetch(names, name), names}
  end

  def handle_call(:stop, _from, state) do
    for {_name, pid} <- HashDict.to_list(state) do
      Logger.info("#{inspect pid}")
      :ok = Agent.KV.Bucket.stop(pid)
    end
    {:stop, :normal, :ok, nil}
  end

  def handle_cast({:create, name}, names) do
    if HashDict.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, bucket} = Agent.KV.Bucket.start_link()
      true = Process.link(bucket)
      {:noreply, HashDict.put(names, name, bucket)}
    end
  end
end
