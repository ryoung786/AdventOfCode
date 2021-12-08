defmodule Aoc.Year2021.Day08 do
  use Aoc.DayBase

  @doc """
   aaaa
  b    c
  b    c
   dddd
  e    f
  e    f
   gggg
  """

  def part_one(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(fn line ->
      [_, out] = String.split(line, " | ") |> Enum.map(&String.split/1)
      Enum.count(out, fn word -> String.length(word) in [2, 3, 4, 7] end)
    end)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(&compute_digits/1)
    |> Enum.sum()
  end

  def compute_digits(line) do
    [patterns, output] = String.split(line, " | ") |> Enum.map(&String.split/1)
    lookup = decode(patterns, output)

    output
    |> Enum.map(fn word -> lookup[word |> String.graphemes() |> MapSet.new()] end)
    |> Integer.undigits()
  end

  def decode(input, _output) do
    # The goal is to map each number to a string containing its "on" segments
    nums = %{
      Enum.into(Enum.reduce(0..9, %{}, &Map.put(&2, &1, nil)), %{})
      | 1 => Enum.find(input, fn word -> String.length(word) == 2 end),
        4 => Enum.find(input, fn word -> String.length(word) == 4 end),
        7 => Enum.find(input, fn word -> String.length(word) == 3 end),
        8 => Enum.find(input, fn word -> String.length(word) == 7 end)
    }

    a = (String.graphemes(nums[7]) -- String.graphemes(nums[1])) |> hd()
    bd = String.graphemes(nums[4]) -- String.graphemes(nums[1])

    {nine, g} =
      Enum.find_value(input, fn word ->
        diff = String.graphemes(word) -- String.graphemes(nums[4] <> a)
        if String.length(word) == 6 && Enum.count(diff) == 1, do: {word, hd(diff)}
      end)

    {three, dg} =
      input
      |> Enum.filter(fn word -> String.length(word) == 5 end)
      |> Enum.find_value(fn word ->
        diff = String.graphemes(word) -- String.graphemes(nums[7])
        if Enum.count(diff) == 2, do: {word, diff}
      end)

    d = hd(dg -- [g])
    b = hd(bd -- [d])

    zero_and_six =
      Enum.filter(input, fn word ->
        String.length(word) == 6 && word != nine && word != three
      end)

    six = Enum.find(zero_and_six, &String.contains?(&1, d))
    zero = zero_and_six |> Enum.find(fn word -> word != six end)

    five_and_two =
      Enum.filter(input, fn word ->
        String.length(word) == 5 && word != three
      end)

    five = five_and_two |> Enum.find(fn word -> String.contains?(word, b) end)
    two = five_and_two |> Enum.find(fn word -> !String.contains?(word, b) end)

    %{nums | 0 => zero, 2 => two, 3 => three, 5 => five, 6 => six, 9 => nine}
    |> Enum.map(fn {n, str} -> {str |> String.graphemes() |> MapSet.new(), n} end)
    |> Enum.into(%{})
  end
end
