defmodule Aoc.Year2021.Day13 do
  use Aoc.DayBase

  def part_one(input) do
    {points, [fold | _rest]} = parse_input(input)

    points
    |> do_fold(fold)
    |> Enum.count()
  end

  def part_two(input) do
    {points, folds} = parse_input(input)
    Enum.reduce(folds, points, fn fold, points -> do_fold(points, fold) end)

    "LRGPRECB"
  end

  def parse_input(input) do
    [points, folds] = input |> String.split("\n\n", trim: true)

    # points
    points =
      points
      |> Input.to_str_list()
      |> Enum.map(fn line ->
        [x, y] = line |> String.split(",") |> Enum.map(&String.to_integer/1)
        {x, y}
      end)

    folds =
      folds
      |> Input.to_str_list()
      |> Enum.map(fn line ->
        [_, axis, val] = Regex.run(~r/(x|y)=([0-9]+$)/, line)
        {axis, String.to_integer(val)}
      end)

    {points, folds}
  end

  def do_fold(points, {axis, val}) do
    Enum.reduce(points, [], fn {x, y}, acc ->
      case axis do
        "x" ->
          {new_x, new_y} = if x > val, do: {2 * val - x, y}, else: {x, y}
          [{new_x, new_y} | acc]

        "y" ->
          {new_x, new_y} = if y > val, do: {x, 2 * val - y}, else: {x, y}
          [{new_x, new_y} | acc]
      end
    end)
    |> Enum.uniq()
  end

  # alias VegaLite, as: Vl
  # points = Enum.map(points, fn {x,y} -> %{x: x, y: y} end) |> Enum.sort()
  # Vl.new(width: 800, height: 100, background: "white")
  # |> Vl.data_from_values(points)
  # |> Vl.mark(:square)
  # |> Vl.encode_field(:x, "x")
  # |> Vl.encode_field(:y, "y")
end
