defmodule Ablation.TopPageHandler do
  require Logger

  def init(req, opts) do
    html = get_html()
    req = :cowboy_req.reply(200,[{"content-type", "text/html"}], html, req)
    {:ok, req, opts}
  end

  def get_html do
    {:ok, cwd} = :file.get_cwd()
    filename = :filename.join([cwd, "priv", "ws_client.html"])
    {:ok, binary} = :file.read_file(filename)
    binary
  end

  def terminate(reason, _req, _state) do
    Logger.info "terminate : #{reason}"
    :ok
  end
end
