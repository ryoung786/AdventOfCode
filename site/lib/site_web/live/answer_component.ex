defmodule SiteWeb.AnswerComponent do
  use SiteWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
      <section class="phx-hero">
    <h1><%= gettext "Day %{day}", day: @day %></h1>
    <p>
      <a href="<%= official_site(@day) %>">problem</a> :: <a href="<%= gh_path(@day) %>">solution</a>
    </p>
    <p><%= @part_one %></p>
    <p><%= @part_two %></p>
    </section>
    """
  end

  defp gh_path(day) do
    gh_base = "https://github.com/ryoung786/AdventOfCode/blob/main/2020/lib/days/"

    day_str = String.pad_leading(day, 2, "0")

    if String.to_integer(day) in 1..25,
      do: gh_base <> "#{day_str}/d_#{day_str}.ex",
      else: "/"
  end

  defp official_site(day) do
    url_base = "https://adventofcode.com/2020/day/"

    if String.to_integer(day) in 1..25,
      do: url_base <> day,
      else: "/"
  end
end
