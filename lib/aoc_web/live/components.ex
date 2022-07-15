defmodule AocWeb.Components do
  use AocWeb, :component

  @url_base "https://github.com/ryoung786/AdventOfCode/blob/main/lib/aoc/years"

  def answer(assigns) do
    ~H"""
    <section class="phx-hero">
      <h1><%= gettext "Day %{day}", day: @day %></h1>
      <p>
        <a href={official_site(@year, @day)}>problem</a> :: <a href={gh_path(@year, @day)}>solution</a>
      </p>
      <p>Part one: <%= @part_one %></p>
      <p>Part two: <%= @part_two %></p>
    </section>
    """
  end

  defp gh_path(year, day) when year in [2021, 2020, 2019] do
    day = String.pad_leading("#{day}", 2, "0")

    if String.to_integer(day) in 1..25,
      do: "#{@url_base}/#{year}/day_#{day}.ex",
      else: "/"
  end

  defp gh_path(_year, _day), do: "/"

  defp official_site(year, day) when year in [2021, 2020, 2019] do
    if day in 1..25,
      do: "https://adventofcode.com/#{year}/day/#{day}",
      else: "/"
  end

  defp official_site(_year, _day), do: "https://adventofcode.com"
end
