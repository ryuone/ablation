defmodule Ablation do
  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    dispatch = :cowboy_router.compile([
      # {HostMatch, list({PathMatch, Handler, Opts})}
      {:_, [
        {"/", Ablation.TopPageHandler, []},
        {"/websocket", Ablation.WebsocketHandler, []},

        {"/static/[...]", :cowboy_static, {
          :priv_dir, :ablation, "static",
          [
            {:mimetypes, :cow_mimetypes, :all},
            {:etag, false}
          ]}}
      ]}
    ])

    port = Application.get_env(:ablation, :port)

    # Name, NbAcceptors, TransOpts, ProtoOpts
    {:ok, _} = :cowboy.start_http(:ablation_http_listener,
                                  100,
                                  [port: port],
                                  [env: [dispatch: dispatch]]
                                )
    Logger.info("Server start on port #{port}")

    Ablation.ClientGroup.start()

    children = []
    opts = [strategy: :one_for_one, name: Ablation.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
