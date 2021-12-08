defmodule Aoc.Year2021.Day08 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(fn str ->
      [_, output] = String.split(str, "| ", trim: true)

      output
      |> String.split(" ", trim: true)
      |> Enum.count(fn word -> String.length(word) in [2, 3, 4, 7] end)
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
    [patterns, output] = String.split(line, " | ", trim: true) |> Enum.map(&String.split/1)

    lookup = decode(patterns, output)

    output
    |> Enum.map(fn word ->
      key = word |> String.graphemes() |> MapSet.new()
      lookup[key]
    end)
    |> Integer.undigits()
  end

  def decode(input, _output) do
    nums = %{
      0 => nil,
      1 => Enum.find(input, fn word -> String.length(word) == 2 end),
      2 => nil,
      3 => nil,
      4 => Enum.find(input, fn word -> String.length(word) == 4 end),
      5 => nil,
      6 => nil,
      7 => Enum.find(input, fn word -> String.length(word) == 3 end),
      8 => Enum.find(input, fn word -> String.length(word) == 7 end),
      9 => nil
    }

    m = %{
      "a" => ~w(a b c d e f g),
      "b" => ~w(a b c d e f g),
      "c" => ~w(a b c d e f g),
      "d" => ~w(a b c d e f g),
      "e" => ~w(a b c d e f g),
      "f" => ~w(a b c d e f g),
      "g" => ~w(a b c d e f g)
    }

    {nums, _} =
      {nums, m}
      |> find_a()
      |> find_b()
      |> find_g(input)
      |> find_3_0(input)
      |> find_5(input)

    Enum.map(nums, fn {n, str} ->
      {str |> String.graphemes() |> MapSet.new(), n}
    end)
    |> Enum.into(%{})
  end

  def find_a({nums, m}) do
    {nums, %{m | "a" => String.graphemes(nums[7]) -- String.graphemes(nums[1])}}
  end

  def find_b({nums, m}) do
    bd = String.graphemes(nums[4]) -- String.graphemes(nums[1])
    {nums, %{m | "b" => bd, "d" => bd}}
  end

  def find_g({nums, m}, input) do
    [a] = m["a"]

    {nine, g} =
      input
      |> Enum.find_value(fn word ->
        diff = String.graphemes(word) -- String.graphemes(nums[4] <> a)
        if String.length(word) == 6 && Enum.count(diff) == 1, do: {word, diff}
      end)

    {%{nums | 9 => nine}, %{m | "g" => g}}
  end

  def find_3_0({nums, m}, input) do
    {three, dg} =
      input
      |> Enum.filter(fn word -> String.length(word) == 5 end)
      |> Enum.find_value(fn word ->
        diff = String.graphemes(word) -- String.graphemes(nums[7])
        if Enum.count(diff) == 2, do: {word, diff}
      end)

    d = dg -- m["g"]
    b = m["b"] -- d

    {nums, m} = {%{nums | 3 => three}, %{m | "b" => b, "d" => d}}

    zero_and_six =
      input
      |> Enum.filter(fn word -> String.length(word) == 6 && word != nums[9] && word != three end)

    six =
      zero_and_six
      |> Enum.find(fn word ->
        [d] = d
        String.contains?(word, d)
      end)

    zero = zero_and_six |> Enum.find(fn word -> word != six end)

    {%{nums | 0 => zero, 6 => six}, m}
  end

  def find_5({nums, m}, input) do
    five_and_two =
      input
      |> Enum.filter(fn word -> String.length(word) == 5 end)
      |> Enum.filter(fn word -> word != nums[3] end)

    [b] = m["b"]
    five = five_and_two |> Enum.find(fn word -> String.contains?(word, b) end)
    two = five_and_two |> Enum.find(fn word -> !String.contains?(word, b) end)

    {%{nums | 2 => two, 5 => five}, m}
  end
end
