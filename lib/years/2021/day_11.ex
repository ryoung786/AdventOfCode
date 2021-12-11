defmodule Aoc.Year2021.Day11 do
  use Aoc.DayBase
  alias Aoc.Utils.Matrix

  def part_one(input) do
    input
    |> Matrix.from_string()
    |> count_flashes(100)
  end

  def part_two(input) do
    input
    |> Matrix.from_string()
  end

  def count_flashes(%Matrix{} = m, num_steps) do
    0..(num_steps - 1)
    |> Enum.reduce({0, m}, fn _step_num, {total_flashes, m} ->
      next = step(m)
      flashes = Matrix.count(next, fn _, _, val -> val == 0 end)
      {total_flashes + flashes, next}
    end)
    |> elem(0)
  end

  def step(%Matrix{} = m) do
    m
    |> Matrix.map(&inc/3)
    |> flash_cycle()
    |> Matrix.map(fn
      _, _, val when val > 9 -> 0
      _, _, val -> val
    end)
  end

  def inc({x, y}, val), do: inc(x, y, val)
  def inc(_x, _y, val), do: val + 1

  def flash_cycle(%Matrix{} = m) do
    flash_cycle(m, Matrix.filter(m, fn _x, _y, val -> val == 10 end))
  end

  def flash_cycle(%Matrix{} = m, [] = _to_process) do
    m
  end

  def flash_cycle(%Matrix{} = m, [{xy, _} | to_process]) do
    neighbors =
      Matrix.all_neighbors(m, xy)
      |> Map.map(fn {xy, val} -> inc(xy, val) end)

    new_flash = Enum.filter(neighbors, fn {_xy, val} -> val == 10 end)

    flash_cycle(
      Matrix.put(m, neighbors),
      to_process ++ new_flash
    )
  end
end
