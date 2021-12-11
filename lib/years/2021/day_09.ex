defmodule Aoc.Year2021.Day09 do
  use Aoc.DayBase
  alias Aoc.Utils.Matrix

  def part_one(input) do
    input
    |> Matrix.from_string()
    |> find_lowest_points()
    |> Enum.map(&risk_level/1)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Matrix.from_string()
    |> find_basins()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def risk_level(val), do: val + 1

  def find_lowest_points(%Matrix{w: w, h: h} = m) do
    for x <- 0..(w - 1), y <- 0..(h - 1), reduce: [] do
      acc ->
        val = Matrix.at(m, x, y)
        neighbors = Matrix.neighbors(m, x, y) |> Map.values()
        if val < Enum.min(neighbors), do: [val | acc], else: acc
    end
  end

  def find_basins(%Matrix{w: w, h: h} = m) do
    for x <- 0..(w - 1), y <- 0..(h - 1), reduce: {[], []} do
      {basins, placed} ->
        if {x, y} in placed do
          {basins, placed}
        else
          basin = find_basin(m, {x, y})
          {[basin | basins], add_to_placed(basin, placed)}
        end
    end
    |> elem(0)
    |> Enum.map(&Enum.count/1)
  end

  def add_to_placed(basin, placed),
    do: Enum.reduce(basin, placed, fn xy, points -> [xy | points] end)

  def find_basin(%Matrix{} = m, {x, y} = xy) when is_integer(x) and is_integer(y) do
    find_basin(m, [xy], [], [])
  end

  def find_basin(%Matrix{}, [] = _queue, basin, _seen), do: basin

  def find_basin(%Matrix{} = m, [{x, y} = xy | queue], basin, seen) do
    val = Matrix.at(m, xy)

    if val == 9 or is_nil(val) do
      find_basin(m, queue, basin, [xy | seen])
    else
      queue =
        [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
        |> Enum.reject(fn pos -> pos in queue || pos in seen end)
        |> Enum.concat(queue)

      find_basin(m, queue, [xy | basin], [xy | seen])
    end
  end
end
