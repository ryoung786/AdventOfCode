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
    |> count_steps_until_synchronized()
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

  def count_steps_until_synchronized(%Matrix{} = m) do
    1..999_999_999
    |> Enum.reduce_while(m, fn step_num, m ->
      next = step(m)
      if is_synchronized?(next), do: {:halt, step_num}, else: {:cont, next}
    end)
  end

  def is_synchronized?(%Matrix{} = m),
    do: Matrix.count(m, fn _, _, val -> val == 0 end) == 100

  def step(%Matrix{} = m) do
    m
    |> Matrix.map(&inc/1)
    |> flash()
    |> Matrix.map(fn val -> if val > 9, do: 0, else: val end)
  end

  def inc(val), do: val + 1

  def flash(%Matrix{} = m) do
    queue = m |> Matrix.with_xy() |> Matrix.filter(fn {_xy, val} -> val == 10 end)
    flash(m, queue)
  end

  def flash(%Matrix{} = m, [] = _to_process), do: m

  def flash(%Matrix{} = m, [{xy, _} | to_process]) do
    neighbors =
      Matrix.all_neighbors(m, xy)
      |> Map.new(fn {_xy, val} -> inc(val) end)

    new_flash = Enum.filter(neighbors, fn {_xy, val} -> val == 10 end)

    flash(
      Matrix.put(m, neighbors),
      to_process ++ new_flash
    )
  end
end
