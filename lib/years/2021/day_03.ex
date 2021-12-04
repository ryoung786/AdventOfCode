defmodule Aoc.Year2021.Day03 do
  use Aoc.DayBase

  def part_one(input) do
    gamma =
      input
      |> Input.to_str_list()
      |> Enum.map(&String.graphemes/1)
      |> transpose()
      |> Enum.map_join(&most_common_digit(&1))
      |> base2to10()

    len = String.split(input, "\n") |> List.first() |> String.length()
    epsilon = Bitwise.bxor(gamma, Integer.pow(2, len) - 1)

    gamma * epsilon
  end

  def part_two(input) do
    entries = input |> Input.to_str_list()
    rating(entries, :o2) * rating(entries, :co2)
  end

  defp transpose(m), do: m |> Enum.zip() |> Enum.map(fn tup -> Tuple.to_list(tup) end)
  defp base2to10(str), do: Integer.parse(str, 2) |> elem(0)

  defp rating(numbers, bit_criteria),
    do: reduce_to_one_number(numbers, bit_criteria) |> base2to10()

  defp reduce_to_one_number(numbers, bit_criteria) do
    0..999
    |> Enum.reduce_while(numbers, fn bit_position, numbers ->
      digit =
        numbers
        |> Enum.map(&String.at(&1, bit_position))
        |> most_common_digit(bit_criteria)

      case numbers |> match_digit(bit_position, digit) do
        [result] -> {:halt, result}
        remaining -> {:cont, remaining}
      end
    end)
  end

  defp match_digit(nums, bit_position, digit) do
    Enum.filter(nums, fn num ->
      String.at(num, bit_position) == digit
    end)
  end

  defp most_common_digit(lst, bit_criteria \\ :o2) do
    zeros = Enum.frequencies(lst) |> Map.get("0", 0)
    ones = Enum.frequencies(lst) |> Map.get("1", 0)

    if bit_criteria == :o2 do
      if ones >= zeros, do: "1", else: "0"
    else
      if ones >= zeros, do: "0", else: "1"
    end
  end
end
