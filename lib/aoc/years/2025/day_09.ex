defmodule Aoc.Year2025.Day09 do
  use Aoc.DayBase

  def part_one(input) do
    area = fn [{x1, y1}, {x2, y2}] ->
      (x2 - x1 + 1) * (y2 - y1 + 1)
    end

    input
    |> parse()
    |> Combination.combine(2)
    |> Enum.map(area)
    |> Enum.max()
  end

  def part_two(input) do
    # input |> Input.to_str_list() |> to_svg()

    points = parse(input)
    lines = [List.last(points) | points] |> Enum.chunk_every(2, 1, :discard)

    intersect? = fn [{x1, y1}, {x2, y2}], [{x3, y3}, {x4, y4}] ->
      cond do
        x1 == x2 && x3 == x4 ->
          # both are vertical lines, so ignore
          false

        y1 == y2 && y3 == y4 ->
          # both are horizontal lines, so ignore
          false

        x1 == x2 && y3 == y4 ->
          min(y1, y2) < y3 && max(y1, y2) > y3 && x1 > x3 && x1 < x4

        y1 == y2 && x3 == x4 ->
          min(x1, x2) < x3 && max(x1, x2) > x3 && y1 > y3 && y1 < y4
      end
    end

    contained? = fn [{x1, y1}, {x2, y2}] = rect ->
      top_left = {min(x1, x2), min(y1, y2)}
      top_right = {max(x1, x2), min(y1, y2)}
      bot_left = {min(x1, x2), max(y1, y2)}
      bot_right = {max(x1, x2), max(y1, y2)}
      top = [top_left, top_right]
      bot = [bot_left, bot_right]
      left = [top_left, bot_left]
      right = [top_right, bot_right]

      log = match?([{2, 3}, {9, 5}], rect)

      Enum.all?([top, bot, left, right], fn line1 ->
        # true if line1 is inside the polygon
        Enum.all?(lines, fn line2 ->
          v = not intersect?.(line1, line2)
          if log, do: IO.inspect({v, line1, line2}, label: "[xxx] ")
          v
        end)
      end)
    end

    Combination.combine(points, 2)
    |> Enum.filter(contained?)
    |> Enum.map(&area/1)
    |> Enum.max()
    |> dbg()
  end

  def area([{x1, y1}, {x2, y2}]) do
    (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
  end

  def parse(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(fn str ->
      str |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  def to_svg(points) do
    File.write(
      "/tmp/aoc.svg",
      """
      <svg width="1200" height="800" viewBox="0 0 100000 100000" xmlns="http://www.w3.org/2000/svg">
        <polygon points="#{Enum.join(points, " ")}" fill="green" stroke="red" stroke-width="200"/>
      </svg>
      """
    )

    File.write(
      "/tmp/aoc2.svg",
      """
      <svg width="1200" height="800" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
        <polygon points="#{Enum.join(points, " ")}" fill="green" stroke="red" stroke-width=".1"/>
      </svg>
      """
    )
  end

  def example() do
    """
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """
    |> String.trim()
  end
end
