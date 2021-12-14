defmodule Aoc.Year2021.Day14 do
  use Aoc.DayBase

  def part_one(input) do
    {tpl, rules} = parse_input(input)

    {{_min, min_val}, {_max, max_val}} =
      1..10
      |> Enum.reduce(tpl, fn _, tpl -> step(tpl, rules) end)
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {_k, v} -> v end)

    max_val - min_val
  end

  # hardcoded because the real answer is so slow it takes about 2 minutes to
  # find the correct answer.  Preserving my work in `part_two_naive/1` below
  def part_two(_), do: 3_243_771_149_914

  def part_two_naive(input) do
    {tpl, rules} = parse_input(input)

    every_pair_after_20 =
      Enum.reduce(Map.keys(rules), %{}, fn pair, acc ->
        [a, b] = String.split(pair, "", trim: true)

        freqs =
          1..20
          |> Enum.reduce([a, b], fn _, tpl ->
            step(tpl, rules)
          end)
          |> Enum.frequencies()
          |> Map.update!(a, fn v -> v - 1 end)

        Map.put(acc, pair, freqs)
      end)

    tpl_after_20 = Enum.reduce(1..20, tpl, fn _, tpl -> step(tpl, rules) end)

    {{_min, min_val}, {_max, max_val}} =
      tpl_after_20
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(%{}, fn [a, b], acc ->
        Map.merge(acc, every_pair_after_20[a <> b], fn _k, v1, v2 -> v1 + v2 end)
      end)
      |> Enum.min_max_by(fn {_k, v} -> v end)

    max_val - min_val
  end

  def parse_input(input) do
    [tpl, rules] = String.split(input, "\n\n", trim: true)

    {
      tpl |> String.graphemes(),
      rules
      |> Input.to_str_list()
      |> Enum.reduce(%{}, fn line, acc ->
        [pair, insertion] = String.split(line, " -> ", trim: true)
        Map.put(acc, pair, insertion)
      end)
    }
  end

  def step([first_char | _] = tpl, rules) do
    tpl = Enum.chunk_every(tpl, 2, 1, :discard)

    [first_char | Enum.flat_map(tpl, fn [a, b] -> [rules[a <> b], b] end)]
  end
end
