defmodule Ablation.WebsocketHandler do
  @behaviour :cowboy_websocket
  require Logger

  def init(req, _opts) do
    Ablation.ClientGroup.join self
    :erlang.start_timer(1000, self, :ping)
    {:cowboy_websocket, req, :undefined_state}
  end

  # Recived from client.
  def websocket_handle({:text, msg}, req, state) do
    Ablation.ClientGroup.send_msg self, msg
    {:reply, {:text, "I said, \"" <> msg <> "\""}, req, state}
  end
  def websocket_handle(_data, req, state) do
    {:ok, req, state}
  end

  # Recived from own process.
  def websocket_info({:timeout, _ref, :ping}, req, state) do
    :erlang.start_timer(10000, self, :ping)
    {:reply, {:ping, ""}, req, state}
  end
  def websocket_info({:timeout, _ref, msg}, req, state) do
    {:reply, {:text, msg}, req, state}
  end
  def websocket_info({_, {:send_message, msg}}, req, state) do
    {:reply, [{:text, msg}], req, state}
  end
  def websocket_info(_info, req, state) do
    {:ok, req, state}
  end

  def terminate(reason, _req, _state) do
    Logger.info("terminate : #{inspect reason}")
    :ok
  end
end
