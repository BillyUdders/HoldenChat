defmodule HoldenChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HoldenChatWeb.Telemetry,
      HoldenChat.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:holden_chat, :ecto_repos), skip: skip_migrations?()},
      {Oban,
       AshOban.config(
         Application.fetch_env!(:holden_chat, :ash_domains),
         Application.fetch_env!(:holden_chat, Oban)
       )},
      # Start a worker by calling: HoldenChat.Worker.start_link(arg)
      # {HoldenChat.Worker, arg},
      # Start to serve requests, typically the last entry
      {DNSCluster, query: Application.get_env(:holden_chat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HoldenChat.PubSub},
      HoldenChatWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :holden_chat]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HoldenChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HoldenChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end
end
