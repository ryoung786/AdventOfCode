defmodule Aoc.Year2020.Day02 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> parse()
    |> Enum.count(fn {min, max, letter, password} ->
      num_occurrences =
        password
        |> String.graphemes()
        |> Enum.frequencies()
        |> Map.get(letter)

      num_occurrences in min..max
    end)
  end

  def part_two(input) do
    input
    |> parse()
    |> Enum.count(fn {i, j, letter, password} ->
      a = String.at(password, i - 1)
      b = String.at(password, j - 1)

      a != b and (a == letter or b == letter)
    end)
  end

  defp parse(input) do
    re = ~r/^\s*(\d+)-(\d+) ([a-z]): (.*)$/

    input
    |> Input.to_str_list()
    |> Enum.map(fn str ->
      [_, i, j, letter, password] = Regex.run(re, str)

      {String.to_integer(i), String.to_integer(j), letter, password}
    end)
  end
end
