defmodule Aoc.Year2020.Day22 do
  use Aoc.DayBase

  def parse_input(str) do
    str
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn [_title | deck] -> Enum.map(deck, &String.to_integer/1) end)
  end

  @impl true
  def part_one(str) do
    [p1, p2] = parse_input(str)
    play_to_end(p1, p2) |> winning_score()
  end

  @impl true
  def part_two(str) do
    [p1, p2] = parse_input(str)
    play_to_end2(p1, p2) |> elem(1) |> winning_score()
  end

  def play_to_end(p1, []), do: p1
  def play_to_end([], p2), do: p2
  def play_to_end([a | p1], [b | p2]) when a > b, do: play_to_end(p1 ++ [a, b], p2)
  def play_to_end([a | p1], [b | p2]) when b > a, do: play_to_end(p1, p2 ++ [b, a])

  def winning_score(deck) do
    deck
    |> Enum.reverse()
    |> Enum.zip(1..Enum.count(deck))
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end

  def play_to_end2(p1, p2, prev \\ [])
  def play_to_end2(p1, [], _prev), do: {:p1, p1}
  def play_to_end2([], p2, _prev), do: {:p2, p2}

  def play_to_end2([a | p1] = d1, [b | p2] = d2, prev) do
    if {d1, d2} in prev do
      {:p1, d1}
    else
      if Enum.count(p1) >= a and Enum.count(p2) >= b do
        case play_to_end2(Enum.take(p1, a), Enum.take(p2, b)) do
          {:p1, _} -> play_to_end2(p1 ++ [a, b], p2, prev ++ [{d1, d2}])
          {:p2, _} -> play_to_end2(p1, p2 ++ [b, a], prev ++ [{d1, d2}])
        end
      else
        if a > b,
          do: play_to_end2(p1 ++ [a, b], p2, prev ++ [{d1, d2}]),
          else: play_to_end2(p1, p2 ++ [b, a], prev ++ [{d1, d2}])
      end
    end
  end
end
