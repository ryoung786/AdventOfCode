defmodule Aoc.Year2021.Day15 do
  use Aoc.DayBase
  alias Aoc.Utils.Matrix
  import Astar

  def part_one(input) do
    input
    |> Matrix.from_string()
    |> find_least_risky_path()
  end

  def part_two(input) do
    input
    |> Matrix.from_string()
    |> find_least_risky_path(:tiled)
  end

  def find_least_risky_path(%Matrix{w: w, h: h} = m, tiled? \\ false) do
    {goal_x, goal_y} = if tiled?, do: {5 * w - 1, 5 * h - 1}, else: {w - 1, h - 1}

    nbrs = fn {x, y} ->
      [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.filter(fn {a, b} -> a in 0..goal_x and b in 0..goal_y end)
    end

    heuristic = fn {a, b}, {x, y} -> abs(x - a) + abs(y - b) end
    edge_cost = fn _, xy -> cost(m, xy, tiled?) end

    astar({nbrs, edge_cost, heuristic}, {0, 0}, {goal_x, goal_y})
    |> Enum.map(&cost(m, &1, tiled?))
    |> Enum.sum()
  end

  defp cost(m, xy, tiled?) do
    if tiled?, do: tiled_risk(m, xy), else: Matrix.at(m, xy)
  end

  def tiled_risk(%Matrix{w: w, h: h} = m, {x, y}) do
    {tile_x, xx} = {div(x, w), rem(x, w)}
    {tile_y, yy} = {div(y, h), rem(y, h)}

    cost = Matrix.at(m, {xx, yy}) + tile_x + tile_y
    if cost > 9, do: cost - 9, else: cost
  end
end
