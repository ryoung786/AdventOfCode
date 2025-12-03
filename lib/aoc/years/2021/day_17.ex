defmodule Aoc.Year2021.Day17 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> to_target_range()
    |> find_valid_slopes()
    |> highest_position()
  end

  def part_two(input) do
    input
    |> to_target_range()
    |> find_valid_slopes()
    |> Enum.count()
  end

  def to_target_range(str) do
    [_, xrange, yrange] = Regex.run(~r/target area: x=(.*), y=(.*)$/, str)
    {Code.eval_string(xrange) |> elem(0), Code.eval_string(yrange) |> elem(0)}
  end

  def in_target?(xtarget, ytarget, {x, y}), do: x in xtarget and y in ytarget
  def beyond_target?(_..xmax//1, ymin.._//1, {x, y}), do: x > xmax or y < ymin

  def find_valid_slopes({_xmin..xmax//1 = xtarget, ymin.._ymax//1 = ytarget}) do
    for dx <- 1..xmax, dy <- ymin..100 do
      points = plot_course(dx, dy, xtarget, ytarget)
      {dx, dy, points}
    end
    |> Enum.filter(fn {_dx, _dy, points} ->
      Enum.any?(points, fn point -> in_target?(xtarget, ytarget, point) end)
    end)
  end

  def highest_position(shots) do
    shots
    |> Enum.map(fn {_, _, points} ->
      {_highest_x, highest_y} = Enum.max_by(points, fn {_x, y} -> y end)
      highest_y
    end)
    |> Enum.max()
  end

  def plot_course(dx, dy, xtarget, ytarget) do
    1..999
    |> Enum.reduce_while([{0, 0, dx, dy}], fn _, [{x, y, dx, dy} | _] = acc ->
      {x, y} = {x + dx, y + dy}

      dy = dy - 1
      dx = update_x_velocity(dx)

      if beyond_target?(xtarget, ytarget, {x, y}),
        do: {:halt, acc},
        else: {:cont, [{x, y, dx, dy} | acc]}
    end)
    |> Enum.map(fn {x, y, _, _} -> {x, y} end)
  end

  def update_x_velocity(0), do: 0
  def update_x_velocity(dx) when dx > 0, do: dx - 1
  def update_x_velocity(dx) when dx < 0, do: dx + 1
end
