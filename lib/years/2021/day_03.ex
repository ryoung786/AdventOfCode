defmodule Aoc.Year2021.Day03 do
  use Aoc.DayBase

  def part_one(input) do
    transposed =
      input
      |> Input.to_str_list()
      |> Enum.map(&String.graphemes/1)
      |> transpose()

    gamma = greek_rate(transposed, &Enum.max_by/2)
    epsilon = greek_rate(transposed, &Enum.min_by/2)

    gamma * epsilon
  end

  defp transpose(m), do: m |> Enum.zip() |> Enum.map(fn tup -> Tuple.to_list(tup) end)
  defp base2to10(str), do: Integer.parse(str, 2) |> elem(0)

  defp greek_rate(transposed, f) do
    transposed
    |> Enum.map_join(fn row ->
      {k, _v} = row |> Enum.frequencies() |> f.(fn {_, v} -> v end)
      k
    end)
    |> base2to10()
  end

  def part_two(input) do
    entries = input |> Input.to_str_list()
    calculate_rating(entries, :o2) * calculate_rating(entries, :co2)
  end

  defp calculate_rating(entries, rating) do
    0..99_999_999
    |> Enum.reduce_while(entries, fn col, nums ->
      digit = column(nums, col, rating)

      remaining = nums |> match_rating(digit, col)

      case remaining do
        [result] -> {:halt, result}
        _ -> {:cont, remaining}
      end
    end)
    |> base2to10()
  end

  defp match_rating(nums, rating, col) do
    Enum.filter(nums, fn num ->
      String.at(num, col) == rating
    end)
  end

  defp column(numbers, col, rating) do
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
