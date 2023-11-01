defmodule DesafioOinc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start commanded
      DesafioOinc.App,
      # Start the Ecto repository
      DesafioOinc.Repo,
      # Blog Events
      DesafioOinc.Blog.Supervisor,
      # Start the Telemetry supervisor
      DesafioOincWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DesafioOinc.PubSub},
      # Start Finch
      {Finch, name: DesafioOinc.Finch},
      # Start the Endpoint (http/https)
      DesafioOincWeb.Endpoint
      # Start a worker by calling: DesafioOinc.Worker.start_link(arg)
      # {DesafioOinc.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DesafioOinc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DesafioOincWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
