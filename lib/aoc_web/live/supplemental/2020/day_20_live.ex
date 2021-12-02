defmodule AocWeb.Supplemental.Year2020.Day20Live do
  use AocWeb, :live_view
  import Aoc.Year2020.Day20
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: kick_off_work()
    {:ok, assign(socket, initial_state())}
  end

  defp initial_state() do
    [foo: 3, bar: 4, solved_puzzle: nil, final_puzzle: nil]
  end

  defp kick_off_work() do
    pid = self()

    Task.start_link(fn ->
      solved = input() |> parse_into_tiles() |> solve_puzzle()
      send(pid, %{solved_puzzle: solved})
    end)
  end

  @impl true
  def handle_info(%{solved_puzzle: solved}, socket) do
    pid = self()

    Task.start_link(fn ->
      puzzle = solved |> merge_puzzle() |> mark_sea_monsters()
      send(pid, %{final_puzzle: puzzle})
    end)

    {:noreply, assign(socket, solved_puzzle: solved)}
  end

  @impl true
  def handle_info(%{final_puzzle: puzzle}, socket),
    do: {:noreply, assign(socket, final_puzzle: puzzle)}

  def dim(puzzle) do
    {puzzle |> Enum.map(fn {{x, _y}, _val} -> x end) |> Enum.max(),
     puzzle |> Enum.map(fn {{_x, y}, _val} -> y end) |> Enum.max()}
  end
end
