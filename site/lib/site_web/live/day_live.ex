defmodule SiteWeb.DayLive do
  use SiteWeb, :live_view
  require Logger

  @supplemental_views %{11 => SiteWeb.Day202011Live, 20 => SiteWeb.Day202020Live}

  @impl true
  def mount(%{"day" => day, "year" => 2020}, _session, socket) do
    {:ok, socket |> mount_year(Aoc2020, day)}
  end

  end
  @impl true
  def mount(socket, year_module, day) do
    module = year_module.Days.get_module(day)
    lv_pid = self()

    # We don't have to worry about killing these tasks as they will die when the page is refreshed
    if socket.connected?,
      do: {
        Task.start_link(fn -> send(lv_pid, %{day: day, part_one: module.part_one()}) end),
        Task.start_link(fn -> send(lv_pid, %{day: day, part_two: module.part_two()}) end)
      }

    # Attempt to sync load answers - if it responds in 500ms or less we show the
    # answer straightaway.  This avoids a loading flash of text, esp. for quick problems
    [p1, p2] =
      [Task.async(&module.part_one/0), Task.async(&module.part_two/0)]
      |> Task.yield_many(500)
      |> Enum.map(fn {task, res} ->
        # Shut down the tasks that did not reply nor exit
        res || Task.shutdown(task, :brutal_kill)
      end)

     assign(socket,
       day: day,
       part_one: answer_or_calculating(p1),
       part_two: answer_or_calculating(p2),
       supplemental_view: Map.get(@supplemental_views, String.to_integer(day)))
  end

  defp answer_or_calculating({:ok, {label, val}}), do: "#{label} #{val}"
  defp answer_or_calculating(_), do: "calculating"

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component(@socket, SiteWeb.AnswerComponent, assigns) %>
    <%= if @supplemental_view != nil, do: live_render(@socket, @supplemental_view, id: String.to_atom("day#{assigns.day}")) %>
    """
  end

  @impl true
  def handle_info(%{day: day, part_one: {label, val}}, %{assigns: %{day: s_day}} = socket)
      when day == s_day,
      do: {:noreply, assign(socket, part_one: "#{label} #{val}")}

  @impl true
  def handle_info(%{day: day, part_two: {label, val}}, %{assigns: %{day: s_day}} = socket)
      when day == s_day,
      do: {:noreply, assign(socket, part_two: "#{label} #{val}")}

  @impl true
  def handle_info(msg, socket) do
    Logger.info("[xxx] generic handle info #{inspect(msg)}")
    {:noreply, socket}
  end
end
