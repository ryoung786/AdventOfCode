defmodule Aoc.Year2021.Day17 do
  use Aoc.DayBase

  def part_one(input) do
    {xtarget, ytarget} = _target = to_target_range(input)

    find_valid_slopes(xtarget, ytarget)
  end

  def part_two(input) do
    {xtarget, ytarget} = _target = to_target_range(input)

    find_valid_slopes2(xtarget, ytarget)
  end

  def to_target_range(str) do
    [_, xrange, yrange] = Regex.run(~r/target area: x=(.*), y=(.*)$/, str)

    [ymin, ymax] = String.split(yrange, "..") |> Enum.map(&String.to_integer/1)
    [xmin, xmax] = String.split(xrange, "..") |> Enum.map(&String.to_integer/1)

    {xmin..xmax, ymin..ymax}
  end

  def in_target?(xtarget, ytarget, {x, y}) do
    x in xtarget and y in ytarget
  end

  def beyond_target?(_..xmax, ymin.._, {x, y}) do
    x > xmax or y < ymin
  end

  def find_valid_slopes(_xmin..xmax = xtarget, _ymin.._ymax = ytarget) do
    for dx <- 1..(div(xmax, 2) + 1), dy <- 0..50 do
      points = plot_course(dx, dy, xtarget, ytarget)

      if Enum.any?(points, fn point -> in_target?(xtarget, ytarget, point) end) do
        Enum.max_by(points, fn {_x, y} -> y end) |> elem(1)
      else
        -999_999_999_999_999_999_999_999
      end
    end
    |> Enum.max()
  end

  def find_valid_slopes2(_xmin..xmax = xtarget, ymin.._ymax = ytarget) do
    for dx <- 1..xmax, dy <- ymin..100 do
      points = plot_course(dx, dy, xtarget, ytarget)

      if Enum.any?(points, fn point -> in_target?(xtarget, ytarget, point) end) do
        {dx, dy}
      else
        :nope
      end
    end
    |> Enum.reject(fn val -> val == :nope end)
    |> IO.inspect(label: "valid ")
    |> Enum.count()
  end

  def plot_course(dx, dy, xtarget, ytarget) do
    1..99_999_999_999_999_999
    |> Enum.reduce_while([{0, 0, dx, dy}], fn _, [{x, y, dx, dy} | _] = acc ->
      x = x + dx
      y = y + dy

      dx =
        cond do
          dx > 0 -> dx - 1
          dx < 0 -> dx + 1
          dx == 0 -> 0
        end

      dy = dy - 1

      if beyond_target?(xtarget, ytarget, {x, y}) do
        {:halt, acc}
      else
        {:cont, [{x, y, dx, dy} | acc]}
      end
    end)
    |> Enum.map(fn {x, y, _, _} -> {x, y} end)
  end
end
