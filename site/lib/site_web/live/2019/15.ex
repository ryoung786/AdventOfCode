defmodule SiteWeb.Day201915Live do
  use SiteWeb, :live_view
  alias Aoc2019.Days.D_15, as: D15
  alias Aoc2019.Intcode
  require Logger

  @tick 17

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket, vm: nil, xy: {0, 0}, dir: [1, 4, 2, 3], map: %{}, move_resp: nil, o2: nil)

    socket = if socket.connected?, do: explore(socket), else: socket
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
     <div class="y2019_15">
       <svg width="600" height="600" viewbox="-30 -30 60 60">
         <rect x="0" y="0" width="1" height="1" fill="tomato" />
         <%= for {{x,y}, :wall} <- @map do %>
           <rect class="wall" x="<%= x %>" y="<%= y %>" width="1" height="1" fill="black" />
         <% end %>

         <% {x, y} = @xy %>
         <rect class="robot" x="<%= x %>" y="<%= y %>" width="1" height="1" fill="navy" />
         <%= if @o2 != nil do %>
           <rect class="o2" x="<%= x %>" y="<%= y %>" width="1" height="1" fill="green" />
         <% end %>
       </svg>
     </div>
    """
  end

  @impl true
  def handle_info(:tick, %{assigns: %{move_resp: 2}} = socket) do
    {:noreply, assign(socket, o2: socket.assigns.xy)}
  end

  @impl true
  def handle_info(:tick, socket) do
    %{vm: vm, xy: xy, dir: [input | _] = dir, map: map} = socket.assigns
    Intcode.input(vm, input)
    %{output: [move_resp | _]} = Intcode.run_sync(vm)
    Intcode.flush_output(vm)

    {xy, map} = D15.update(map, xy, input, move_resp)
    dir = D15.turn_robot(dir, move_resp)

    Process.send_after(self(), :tick, @tick)

    {:noreply, assign(socket, xy: xy, dir: dir, map: map, move_resp: move_resp)}
  end

  def explore(socket) do
    vm =
      D15.input()
      |> Aoc2019.Util.to_intcode_program()
      |> D15.start_robot()

    Process.send_after(self(), :tick, 0)

    assign(socket, vm: vm)
  end
end
