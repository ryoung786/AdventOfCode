defmodule SiteWeb.Day201915Live do
  use SiteWeb, :live_view
  alias Aoc2019.Days.D_15, as: D15
  alias Aoc2019.Intcode
  import Astar
  require Logger

  @tick 20
  @tick_gas 60

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        vm: nil,
        xy: {0, 0},
        dir: [1, 4, 2, 3],
        map: %{},
        move_resp: nil,
        o2: nil,
        astar_path: [],
        gas: MapSet.new(),
        edge_of_gas: [],
        gas_minutes: 0
      )

    socket = if socket.connected?, do: explore(socket), else: socket
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
     <div class="y2019_15">
       <div class="answers">
         <h3>Shortest path: <%= if @astar_path != [], do: Enum.count(@astar_path) %></h3>
         <%= if @gas_minutes > 0 do %>
           <h3>Minutes gas expanding: <%= @gas_minutes %></h3>
         <% end %>
       </div>
       <svg width="600" height="600" viewbox="-22 -22 42 42">
         <%= for {{x,y}, :wall} <- @map do %>
           <path class="wall" d="<%= "M#{x} #{y} L#{x} #{y}" %>" stroke="black" stroke-linecap="square" />
         <% end %>

         <% {x, y} = @xy %>
         <path class="robot" d="<%= "M#{x} #{y} L#{x} #{y}" %>" stroke="navy" stroke-linecap="square" />

         <%= if @astar_path != [] do %>
           <path d="<%= to_svg_path(@astar_path) %>" stroke="magenta" fill="none" stroke-linecap="square" />
         <% end %>

         <%= for {x,y} <- @gas do %>
           <path class="gas" d="<%= "M#{x} #{y} L#{x} #{y}" %>" stroke="cyan" stroke-linecap="square" />
         <% end %>

         <%= if @o2 != nil do %>
           <% {x, y} = @o2 %>
           <path class="o2" d="<%= "M#{x} #{y} L#{x} #{y}" %>" stroke="green" stroke-linecap="square" />
         <% end %>

         <path class="origin" d="M0 0 L0 0" stroke="brown" stroke-linecap="square" />
       </svg>
     </div>
    """
  end

  # explore until the robot has found the o2 and has reached the origin again
  @impl true
  def handle_info(:tick, %{assigns: %{xy: {0, 0}, o2: o2}} = socket) when o2 != nil do
    Process.send_after(self(), :astar, 0)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, %{assigns: %{move_resp: 2}} = socket) do
    Process.send_after(self(), :tick, @tick)

    {:noreply,
     assign(socket, o2: socket.assigns.xy, move_resp: nil, edge_of_gas: [socket.assigns.xy])}
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

    {:noreply,
     assign(socket,
       xy: xy,
       dir: dir,
       map: map,
       move_resp: move_resp
     )}
  end

  @impl true
  def handle_info(:astar, %{assigns: %{o2: o2, map: map}} = socket) do
    nbrs = fn {x, y} ->
      [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.reject(fn xy -> Map.get(map, xy) == :wall end)
    end

    path = astar({nbrs, fn _, _ -> 1 end, &heuristic/2}, o2, {0, 0})
    Process.send_after(self(), :expand_gas, 0)
    {:noreply, assign(socket, astar_path: path)}
  end

  @impl true
  def handle_info(:expand_gas, %{assigns: %{gas: gas, edge_of_gas: edges}} = socket) do
    edges = get_neighbors_not_filled_with_gas(edges, gas, socket.assigns.map)
    gas = MapSet.union(gas, MapSet.new(edges))

    minutes =
      if edges != [] do
        Process.send_after(self(), :expand_gas, @tick_gas)
        socket.assigns.gas_minutes + 1
      else
        socket.assigns.gas_minutes
      end

    {:noreply, assign(socket, gas_minutes: minutes, gas: gas, edge_of_gas: edges)}
  end

  defp get_neighbors_not_filled_with_gas(edges, gas, map) do
    edges
    |> Enum.flat_map(&non_wall_neighbors(&1, map))
    |> Enum.reject(fn xy -> xy in gas end)
  end

  defp non_wall_neighbors({x, y}, map) do
    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.reject(fn xy -> Map.get(map, xy) == :wall end)
  end

  defp heuristic({x, y}, {bx, by}),
    do: (:math.pow(x - bx, 2) + :math.pow(y - by, 2)) |> :math.sqrt()

  defp to_svg_path([{a, b} | coords]) do
    path =
      coords
      |> Enum.reduce([], fn {x, y}, acc -> ["L#{x} #{y}" | acc] end)
      |> Enum.reverse()
      |> Enum.join(" ")

    "M#{a} #{b} " <> path
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
