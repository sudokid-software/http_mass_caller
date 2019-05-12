defmodule HttpMassCaller.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    IO.puts("Testing: #{System.get_env("CC")}")
    {children_count, _} = Integer.parse(System.get_env("CC"))
    children = [
      {HttpMassCaller.CallerSup, children_count}
      # Starts a worker by calling: HttpMassCaller.Worker.start_link(arg)
      # {HttpMassCaller.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HttpMassCaller.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
