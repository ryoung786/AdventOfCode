defmodule AocWeb.Day11Live do
  use AocWeb, :live_view
  import Aoc.Days.D_11
  require Logger

  @tick 200

  @impl true
  def mount(_params, _session, socket) do
    if socket.connected?, do: Process.send_after(self(), :next_round, @tick)
    {:ok, assign(socket, initial_state())}
  end

  defp initial_state() do
    room = input() |> parse_input_str()
    [w, h] = dim(room)

    [
      room: room,
      room_b64: to_bmp(room),
      w: w,
      h: h,
      round: 0,
      occupied: 0,
      room2: room,
      room2_b64: to_bmp(room),
      round2: 0,
      occupied2: 0
    ]
  end

  @impl true
  def handle_event("next", _params, socket) do
    {:noreply, assign(socket, room: next_round(socket.assigns.room))}
  end

  @impl true
  def handle_info(:next_round, socket) do
    next = next_round(socket.assigns.room)
    occupied = count_occupied(next)

    next2 = next_round(socket.assigns.room2, :part2)
    occupied2 = count_occupied(next2)
    round2 = socket.assigns.round2 + if next2 == socket.assigns.room2, do: 0, else: 1

    if next != socket.assigns.room, do: Process.send_after(self(), :next_round, @tick)

    {:noreply,
     assign(socket,
       room: next,
       room_b64: to_bmp(next),
       round: socket.assigns.round + 1,
       occupied: occupied,
       room2: next2,
       room2_b64: to_bmp(next2),
       round2: round2,
       occupied2: occupied2
     )}
  end

  defp dim(room) do
    Map.keys(room)
    |> Enum.reduce([[], []], fn {x, y}, [xs, ys] -> [[x | xs], [y | ys]] end)
    |> Enum.map(&Enum.max/1)
  end

  defp count_occupied(room), do: room |> Enum.count(fn {_, state} -> state == :occupied end)
end
