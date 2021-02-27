defmodule SiteWeb.AnswerComponent do
  use SiteWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <h1><%= gettext "Day %{day}", day: @day %></h1>
      <p>
        <a href="<%= official_site(@year, @day) %>">problem</a> :: <a href="<%= gh_path(@year, @day) %>">solution</a>
      </p>
      <p><%= @part_one %></p>
      <p><%= @part_two %></p>
    </section>
    """
  end

  defp gh_path(year, day) when year in ~w(2020 2019) do
    root_url = "https://github.com/ryoung786/AdventOfCode"

    gh_base =
      case year do
        "2020" -> "#{root_url}/blob/main/2020/lib/days/"
        "2019" -> "#{root_url}/blob/main/2019/elixir/lib/days/"
      end

    day_str = String.pad_leading(day, 2, "0")

    if String.to_integer(day) in 1..25,
      do: gh_base <> "#{day_str}/d_#{day_str}.ex",
      else: "/"
  end

  defp gh_path(_year, _day), do: "/"

  defp official_site(year, day) when year in ~w(2020 2019) do
    url_base = "https://adventofcode.com/#{year}/day/"

    if String.to_integer(day) in 1..25,
      do: url_base <> day,
      else: "/"
  end

  defp official_site(_year, _day), do: "https://adventofcode.com"
end
