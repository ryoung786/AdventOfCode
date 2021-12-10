defmodule Aoc.Year2021.Day10 do
  use Aoc.DayBase

  @open ["(", "[", "{", "<"]
  @complementary %{")" => "(", "]" => "[", "}" => "{", ">" => "<"}

  def part_one(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(&score_line/1)
    |> Enum.filter(&is_corrupted/1)
    |> Enum.map(fn {:corrupted, score} -> score end)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(&score_line/1)
    |> Enum.reject(&is_corrupted/1)
    |> Enum.map(fn {:incomplete, score} -> score end)
    |> median()
  end

  def score_line(line) do
    scoring = %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

    score =
      String.graphemes(line)
      |> Enum.reduce_while([], fn
        char, stack when char in @open ->
          {:cont, [char | stack]}

        char, [] ->
          {:halt, scoring[char]}

        char, [a | stack] ->
          if a == @complementary[char],
            do: {:cont, stack},
            else: {:halt, scoring[char]}
      end)

    if is_integer(score), do: {:corrupted, score}, else: {:incomplete, score_autocomplete(score)}
  end

  def score_autocomplete(remaining) do
    score = %{"(" => 1, "[" => 2, "{" => 3, "<" => 4}
    Enum.reduce(remaining, 0, fn char, total -> total * 5 + score[char] end)
  end

  def is_corrupted({status, _score}), do: status == :corrupted

  def median(scores) do
    middle_index = div(Enum.count(scores), 2)
    scores |> Enum.sort() |> Enum.at(middle_index)
  end
end
