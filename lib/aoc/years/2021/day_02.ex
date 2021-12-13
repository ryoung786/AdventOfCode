defmodule Aoc.Year2021.Day02 do
  use Aoc.DayBase

  def part_one(input) do
    {x, y} =
      input
      |> to_command_list()
      |> Enum.reduce({0, 0}, fn {dir, val}, {x, y} ->
        case {dir, val} do
          {"forward", val} -> {x + val, y}
          {"down", val} -> {x, y + val}
          {"up", val} -> {x, y - val}
        end
      end)

    x * y
  end

  def part_two(input) do
    {x, y, _aim} =
      input
      |> to_command_list()
      |> Enum.reduce({0, 0, 0}, fn {dir, val}, {x, y, aim} ->
        case {dir, val} do
          {"forward", val} -> {x + val, y + aim * val, aim}
          {"down", val} -> {x, y, aim + val}
          {"up", val} -> {x, y, aim - val}
        end
      end)

    x * y
  end

  defp to_command_list(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(fn str ->
      [dir, x] = String.split(str)
      {dir, String.to_integer(x)}
    end)
  end
end
