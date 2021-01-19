defmodule SiteWeb.Day201919Live do
  use SiteWeb, :live_view
  alias Aoc2019.Days.D_19, as: D19
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, sleigh_x: nil, sleigh_y: nil, map: %{})

    socket = if socket.connected?, do: explore(socket), else: socket
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
     <div class="y2019_15">
       <div class="answers">
       </div>
       <svg width="600" height="600" viewbox="0 0 1200 1200">
         <%= for {y, {xmin, xmax}} <- @map do %>
           <path class="beam" d="<%= "M#{xmin} #{y} h#{1 + xmax - xmin} v1 h-#{1 + xmax - xmin} z" %>" stroke="none" fill="tomato"  />
         <% end %>

         <%= if @sleigh_x != nil do %>
           <rect x="<%= @sleigh_x %>" y="<%= @sleigh_y %>" width="100" height="100" fill="none" stroke="black"/>
         <% end %>
       </svg>
     </div>
    """
  end

  # <rect x="<%= x %>" y="<%= y %>" width="1" height="1" fill="black" />
  # <path class="beam" d="<%= "M#{x} #{y} L#{x} #{y}" %>" stroke="black" stroke-linecap="square" />

  def explore(socket) do
    prog = D19.input() |> Aoc2019.Util.to_intcode_program()

    # map =
    #   1..1100
    #   |> Enum.reduce([{0, 0, 0}], fn y, acc ->
    #     [{_y, xmin, xmax} | _] = acc
    #     new_xmin = xmin..(xmax + 1) |> Enum.find(fn x -> is_beam_at({x, y}, prog) end)
    #     new_xmax = (xmax + 1)..xmin |> Enum.find(fn x -> is_beam_at({x, y}, prog) end)

    #     if new_xmin == nil,
    #       do: acc,
    #       else: [{y, new_xmin, new_xmax} | acc]
    #   end)
    map = D19.gen_map(prog)
    {x, y} = D19.get_sleigh_xy(prog, map)
    assign(socket, map: map, sleigh_x: x, sleigh_y: y)
  end
end
