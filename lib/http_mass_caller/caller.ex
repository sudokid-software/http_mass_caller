defmodule HttpMassCaller.Caller do
  use GenServer

  def init(state) do
    :ok = :pg2.create(:callers)
    :ok = :pg2.join(:callers, self())
    {:ok, state}
  end

  def child_spec([num]) do
    spec = %{
      id: :"caller#{num}",
      start: {HttpMassCaller.Caller, :start_link, []}
    }
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def spam(:get, url, number_of_calls) do
    Enum.map(
      0..number_of_calls, fn _ ->
        :pg2.get_closest_pid(:callers)
        |> GenServer.cast({:get, url})
      end
    )
    :ok
  end

  def spam(:post, url, number_of_calls, body) do
    Enum.map(
      0..number_of_calls, fn _ ->
        :pg2.get_closest_pid(:callers)
        |> GenServer.cast({:post, url, body})
      end
    )
    :ok
  end

  def handle_cast({:get, url}, state) do
    response = HTTPoison.get!(url)
    IO.puts("Response: status_code-#{response.status_code}")
    {:noreply, state}
  end

  def handle_cast({:post, url, body}, state) do
    response = HTTPoison.post!(url, Jason.encode!(body))
    IO.puts("Response: status_code-#{response.status_code}")
    {:noreply, state}
  end
end

defmodule HttpMassCaller.CallerSup do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(number_of_callers) do
    children = Enum.map(
      1..number_of_callers, fn n ->
        {HttpMassCaller.Caller, [n]}
      end
     )

    Supervisor.init(children, strategy: :one_for_one)
  end
end

