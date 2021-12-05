defmodule Aoc.Year2021.Day05 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> parse_lines()
    |> keep_only_straight_lines()
    |> num_intersections()
  end

  def part_two(input) do
    input
    |> parse_lines()
    |> num_intersections()
  end

  def parse_lines(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(fn str ->
      Regex.run(~r/(\d+),(\d+) -> (\d+),(\d+)/, str)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def keep_only_straight_lines(lines) do
    Enum.filter(lines, fn [x1, y1, x2, y2] ->
      x1 == x2 or y1 == y2
    end)
  end

  def num_intersections(lines) do
    lines
    |> all_points()
    |> Enum.frequencies()
    |> Enum.count(fn {_, n} -> n >= 2 end)
  end

  def all_points(lines) do
    Enum.flat_map(lines, &gen_points/1)
  end

  def gen_points([x1, y1, x2, y2]) do
    case x1 == x2 or y1 == y2 do
      true -> for(x <- x1..x2, y <- y1..y2, do: {x, y})
      _ -> Enum.zip(x1..x2, y1..y2)
    end
  end
end
