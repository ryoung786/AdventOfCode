defmodule Aoc.Year2021.Day21 do
  use Aoc.DayBase

  defmodule State do
    defstruct p1: 0, p1_score: 0, p2: 0, p2_score: 0, num_rolls: 0
  end

  def part_one(input) do
    input
    |> parse_input()
    |> play_game()
    |> then(fn %State{} = s ->
      min(s.p1_score, s.p2_score) * s.num_rolls
    end)
  end

  def part_two(input) do
    {_p1, _p2} = parse_input(input)
    "TBD"
  end

  def parse_input(input) do
    IO.inspect(input, label: "[xxx] ")
    [[_, p1], [_, p2]] = Regex.scan(~r/: (\d+)/, input)
    {String.to_integer(p1), String.to_integer(p2)}
  end

  def play_game({p1, p2}) do
    1..9_999_999_999_999
    |> Enum.reduce_while(%State{p1: p1, p2: p2}, fn n, state ->
      if n < 10, do: IO.inspect(state, label: "::")

      if game_over?(state),
        do: {:halt, state},
        else: {:cont, roll(state)}
    end)
  end

  def game_over?(%State{} = s) do
    s.p1_score >= 1000 or s.p2_score >= 1000
  end

  def roll(%State{} = s) do
    pawn_position = if turn(s) == :p1, do: s.p1, else: s.p2

    dice_sum =
      [s.num_rolls + 1, s.num_rolls + 2, s.num_rolls + 3]
      |> Enum.map(&rem(&1, 100))
      |> Enum.sum()

    new_pos =
      case rem(dice_sum + pawn_position, 10) do
        0 -> 10
        n -> n
      end

    if turn(s) == :p1,
      do: %State{s | p1: new_pos, p1_score: s.p1_score + new_pos, num_rolls: s.num_rolls + 3},
      else: %State{s | p2: new_pos, p2_score: s.p2_score + new_pos, num_rolls: s.num_rolls + 3}
  end

  def turn(%State{} = s), do: if(div(s.num_rolls, 3) |> rem(2) == 0, do: :p1, else: :p2)
end
