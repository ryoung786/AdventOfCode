defmodule AocWeb.AnswerComponent do
  use AocWeb, :live_component

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
    gh_base = "https://github.com/ryoung786/AdventOfCode/blob/main/2020/lib/aoc/days/"

    if String.to_integer(day) in 1..25,
      do: gh_base <> "d_#{String.pad_leading(day, 2, "0")}.ex",
      else: "/"
  end

  defp official_site(day) do
    gh_base = "https://adventofcode.com/2020/day/"

    if String.to_integer(day) in 1..25,
      do: gh_base <> day,
      else: "/"
  end
end
