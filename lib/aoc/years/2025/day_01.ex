defmodule Aoc.Year2025.Day01 do
  use Aoc.DayBase

  def part_one(input) do
    commands = input |> Input.to_str_list()

    {_ending_pos, zeros_hit} =
      Enum.reduce(commands, {50, 0}, fn cmd, {pos, count} ->
        clicks =
          case cmd do
            "L" <> mag -> -1 * String.to_integer(mag)
            "R" <> mag -> String.to_integer(mag)
          end

        pos = Enum.at(0..99, rem(pos + clicks, 100))
        count = if pos == 0, do: count + 1, else: count
        {pos, count}
      end)

    zeros_hit
  end

  def part_two(input) do
    commands = input |> String.replace("L", "-") |> String.replace("R", "") |> Input.to_int_list()

    {_ending_pos, zeros_hit} =
      Enum.reduce(commands, {50, 0}, fn cmd, {pos, count} ->
        count = count + abs(div(cmd, 100))
        cmd = rem(cmd, 100)

        count =
          cond do
            pos + cmd > 99 -> count + 1
            pos == 0 && pos + cmd < 0 -> count
            pos + cmd <= 0 -> count + 1
            true -> count
          end

        pos = Enum.at(0..99, rem(pos + cmd, 100))
        {pos, count}
      end)

    zeros_hit
  end
end
