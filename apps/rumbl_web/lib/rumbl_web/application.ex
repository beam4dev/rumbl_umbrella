defmodule RumblWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # To avoid this issue
      # ** (Mix) Could not start application rumbl_web: RumblWeb.Application.start(:normal, []) returned an error: shutdown: failed to start child: RumblWeb.Presence
      # ** (EXIT) shutdown: failed to start child: Phoenix.Presence.Tracker
      # ** (EXIT) shutdown: failed to start child: RumblWeb.Presence_shard0
      #     ** (EXIT) an exception was raised:
      #         ** (ArgumentError) unknown registry: RumblWeb.PubSub. Either the registry name is invalid or the registry is not running, possibly because its application isn't started
      #             (elixir 1.16.0) lib/registry.ex:1086: Registry.meta/2
      #             (phoenix_pubsub 2.1.3) lib/phoenix/pubsub.ex:274: Phoenix.PubSub.node_name/1
      #             (phoenix_pubsub 2.1.3) lib/phoenix/tracker/shard.ex:122: Phoenix.Tracker.Shard.init/1
      #             (stdlib 5.2) gen_server.erl:980: :gen_server.init_it/2
      #             (stdlib 5.2) gen_server.erl:935: :gen_server.init_it/6
      # add the following line as described here https://elixirforum.com/t/pubsub-in-a-phoenix-app-under-umbrella/31083/14
      {Phoenix.PubSub, name: RumblWeb.PubSub},
      RumblWeb.Telemetry,
      # Start a worker by calling: RumblWeb.Worker.start_link(arg)
      # {RumblWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      RumblWeb.Endpoint,
      RumblWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RumblWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RumblWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
