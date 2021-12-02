defmodule AocWeb.Supplemental.Year2019.Day13Live do
  use AocWeb, :live_view
  alias Aoc.Year2019.Day13, as: D13
  alias Aoc.Utils.Input
  alias Aoc.Intcode
  require Logger

  @tick 500

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, vm: nil, display: %{}, score: 0, input: 0)
    socket = if connected?(socket), do: start_game(socket), else: socket
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
     <div class="y2019_13" phx-window-keydown="joystick" phx-throttle="100">
       <button class="button" phx-click="start">Start Game</button>
       <h3>Score: <%= @score %></h3>
       <svg width="600" height="300" viewbox="0 0 40 20">
         <%= for {{x,y}, tile} <- @display do %>
         <rect x="<%= x %>" y="<%= y %>" width="1" height="1" fill="<%= tile_color(tile) %>" />
         <% end %>
       </svg>
     </div>
    """
  end

  @impl true
  def handle_event("joystick", %{"key" => key}, socket) when key in ~w(ArrowLeft a),
    do: {:noreply, assign(socket, input: -1)}

  @impl true
  def handle_event("joystick", %{"key" => key}, socket) when key in ~w(ArrowRight d),
    do: {:noreply, assign(socket, input: 1)}

  @impl true
  def handle_event("joystick", _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("start", _, socket), do: {:noreply, start_game(socket)}

  @impl true
  def handle_info(:tick, socket) do
    %{vm: vm} = socket.assigns
    Intcode.input(vm, socket.assigns.input)
    Intcode.flush_output(vm)
    state = Intcode.run_sync(vm)

    if state.status != :halted, do: Process.send_after(self(), :tick, @tick)

    {:noreply,
     assign(socket,
       display: update_display(socket.assigns.display, state),
       score: D13.get_score(state) || socket.assigns.score,
       input: 0
     )}
  end

  def tile_color(0), do: "black"
  def tile_color(1), do: "silver"
  def tile_color(2), do: "purple"
  def tile_color(3), do: "teal"
  def tile_color(4), do: "goldenrod"

  def start_game(socket) do
    {vm, state} =
      D13.input()
      |> Input.to_intcode_program()
      |> D13.hack_quarters()
      |> D13.start_game()

    Intcode.flush_output(vm)
    Process.send_after(self(), :tick, 0)

    assign(socket, vm: vm, display: update_display(%{}, state), score: D13.get_score(state) || 0)
  end

  def update_display(display, %{output: output}) do
    output
    |> Enum.chunk_every(3)
    |> Enum.reduce(display, fn
      [_score, 0, -1], display -> display
      [tile, y, x], display -> Map.put(display, {x, y}, tile)
    end)
  end
end
