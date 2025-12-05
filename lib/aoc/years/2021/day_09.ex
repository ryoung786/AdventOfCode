defmodule Aoc.Year2021.Day09 do
  use Aoc.DayBase
  alias Aoc.Utils.Grid

  def part_one(input) do
    g = input |> Grid.new(&String.to_integer/1)

    Enum.filter(g, fn {xy, val} ->
      val < Grid.cardinal_neighbors(g, xy) |> Map.values() |> Enum.min()
    end)
    |> Enum.sum_by(fn {_xy, val} -> val + 1 end)
  end

  def part_two(input) do
    input
    |> Grid.new(&String.to_integer/1)
    |> find_basins()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def find_basins(g) do
    {basins, _placed} =
      Enum.reduce(g, {[], []}, fn {xy, _val}, {basins, placed} ->
        if xy in placed do
          {basins, placed}
        else
          basin = find_basin(g, xy)
          {[basin | basins], basin ++ placed}
        end
      end)

    Enum.map(basins, &Enum.count/1)
  end

  def find_basin(g, xy), do: find_basin(g, [xy], [], [])
  def find_basin(_g, [] = _queue, basin, _seen), do: basin

  def find_basin(g, [{x, y} = xy | queue], basin, seen) do
    if g[xy] in [9, nil] do
      find_basin(g, queue, basin, [xy | seen])
    else
      queue =
        [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
        |> Enum.reject(fn pos -> pos in queue || pos in seen end)
        |> Enum.concat(queue)

      find_basin(g, queue, [xy | basin], [xy | seen])
    end
  end

  def example() do
    """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
    |> String.trim()
  end
end
