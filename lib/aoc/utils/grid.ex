defmodule Aoc.Utils.Grid do
  alias Aoc.Utils.Input

  def new(str, mapper \\ & &1) do
    str
    |> Input.to_str_list()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, m ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(m, fn {ch, x}, m -> Map.put(m, {x, y}, mapper.(ch)) end)
    end)
  end

  def neighbors(g, {x, y}) do
    {w, h} = {width(g) - 1, height(g) - 1}

    for(dx <- -1..1, dy <- -1..1, do: {x + dx, y + dy})
    |> Enum.reject(&(&1 == {x, y}))
    |> Enum.reject(fn {x, y} -> x < 0 || x > w || y < 0 || y > h end)
    |> Map.new(fn xy -> {xy, g[xy]} end)
  end

  def cardinal_neighbors(g, {x, y}) do
    {w, h} = {width(g) - 1, height(g) - 1}

    [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.reject(fn {x, y} -> x < 0 || x > w || y < 0 || y > h end)
    |> Map.new(fn xy -> {xy, g[xy]} end)
  end

  def width(grid) do
    {x, _} = Map.keys(grid) |> Enum.max_by(fn {x, _y} -> x end)
    x + 1
  end

  def height(grid) do
    {_, y} = Map.keys(grid) |> Enum.max_by(fn {_x, y} -> y end)
    y + 1
  end

  def print(grid) do
    rows =
      for y <- 0..(height(grid) - 1) do
        row = for x <- 0..(width(grid) - 1), do: grid[{x, y}]
        Enum.join(row, " ")
      end

    IO.puts(
      "width: #{width(grid)}, height: #{height(grid)}\n" <>
        Enum.join(rows, "\n")
    )
  end
end
