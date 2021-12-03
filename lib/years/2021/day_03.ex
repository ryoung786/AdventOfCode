defmodule Aoc.Year2021.Day03 do
  use Aoc.DayBase

  def part_one(input) do
    [a | _] = entries = input |> Input.to_str_list()
    bitmask = Integer.pow(2, String.length(a)) - 1

    gamma =
      0..(String.length(a) - 1)
      |> Enum.map_join(fn col ->
        column(entries, col)
      end)
      |> Integer.parse(2)
      |> elem(0)

    epsilon = Bitwise.bxor(gamma, bitmask)

    gamma * epsilon
  end

  def part_two(input) do
    [a | _] = entries = input |> Input.to_str_list()

    {o2, _} =
      0..(String.length(a) - 1)
      |> Enum.reduce_while(entries, fn col, nums ->
        rating = column(nums, col, :o2)

        remaining = nums |> match_rating(rating, col)

        case remaining do
          [result] -> {:halt, result}
          _ -> {:cont, remaining}
        end
      end)
      |> Integer.parse(2)

    {co2, _} =
      0..(String.length(a) - 1)
      |> Enum.reduce_while(entries, fn col, nums ->
        rating = column(nums, col, :co2)

        remaining = nums |> match_rating(rating, col)

        case remaining do
          [result] -> {:halt, result}
          _ -> {:cont, remaining}
        end
      end)
      |> Integer.parse(2)

    o2 * co2
  end

  def match_rating(nums, rating, col) do
    Enum.filter(nums, fn num ->
      String.at(num, col) == rating
    end)
  end

  # returns {most_frequent, least_frequent}
  def column(numbers, col, rating \\ :o2) do
    freqs =
      numbers
      |> Enum.map(&String.at(&1, col))
      |> Enum.frequencies()

    zeros = Map.get(freqs, "0", 0)
    ones = Map.get(freqs, "1", 0)

    if rating == :o2 do
      if ones >= zeros, do: "1", else: "0"
    else
      if ones >= zeros, do: "0", else: "1"
    end
  end
end
