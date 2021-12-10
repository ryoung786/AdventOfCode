defmodule Aoc.Year2021.Day10 do
  use Aoc.DayBase

  @scores %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
  @open ["(", "[", "{", "<"]
  @pair %{")" => "(", "]" => "[", "}" => "{", ">" => "<"}
  @auto_scores %{"(" => 1, "[" => 2, "{" => 3, "<" => 4}

  def part_one(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(&score_line/1)
    |> Enum.sum()
  end

  def part_two(input) do
    sorted =
      input
      |> Input.to_str_list()
      |> Enum.reject(fn line -> score_line(line) > 0 end)
      |> Enum.map(&score_autocomplete/1)
      |> Enum.sort()

    # calculate median score
    idx = div(Enum.count(sorted) - 1, 2)
    Enum.at(sorted, idx)
  end

  def score_line(line) do
    score =
      String.graphemes(line)
      |> Enum.reduce_while([], fn
        char, stack when char in @open ->
          {:cont, [char | stack]}

        char, [] ->
          {:halt, @scores[char]}

        char, [a | stack] ->
          if a == @pair[char],
            do: {:cont, stack},
            else: {:halt, @scores[char]}
      end)

    if is_integer(score), do: score, else: 0
  end

  def score_autocomplete(line) do
    remaining =
      String.graphemes(line)
      |> Enum.reduce([], fn
        char, stack when char in @open -> [char | stack]
        _char, [_ | stack] -> stack
      end)

    remaining
    |> tap(fn lst -> IO.inspect(Enum.join(lst), label: "reversed ") end)
    |> Enum.reduce(0, fn char, total_score -> total_score * 5 + @auto_scores[char] end)
  end
end
