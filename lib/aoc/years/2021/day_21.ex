defmodule Aoc.Year2021.Day21 do
  use Aoc.DayBase

  defmodule State do
    defstruct p1: 0, p1_score: 0, p2: 0, p2_score: 0, num_rolls: 0
  end

  defmodule DState do
    defstruct p1: 0, p1_score: 0, p2: 0, p2_score: 0, turn: :p1
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
    input
    |> parse_input()
    |> play_dirac_game()
    |> Enum.max()
  end

  def parse_input(input) do
    [[_, p1], [_, p2]] = Regex.scan(~r/: (\d+)/, input)
    {String.to_integer(p1), String.to_integer(p2)}
  end

  def play_game({p1, p2}) do
    1..9_999_999_999_999
    |> Enum.reduce_while(%State{p1: p1, p2: p2}, fn _, state ->
      if game_over?(state, 1000),
        do: {:halt, state},
        else: {:cont, roll(state)}
    end)
  end

  def game_over?(game, winning_score) do
    cond do
      game.p1_score >= winning_score -> :p1
      game.p2_score >= winning_score -> :p2
      true -> false
    end
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

  def play_dirac_game({p1, p2}) do
    count_wins(%{%DState{p1: p1, p2: p2} => 1}, 0, 0)
  end

  def count_wins(games, p1_wins, p2_wins) when games == %{} do
    [p1_wins, p2_wins]
  end

  def count_wins(games, p1_wins, p2_wins) do
    [{game, count}] = Enum.take(games, 1)
    games = Map.delete(games, game)

    case game_over?(game, 5) do
      :p1 ->
        count_wins(games, p1_wins + count, p2_wins)

      :p2 ->
        count_wins(games, p1_wins, p2_wins + count)

      _ ->
        game
        |> dirac_possibilities()
        |> Map.map(fn {_k, v} -> v * count end)
        |> Map.merge(games, fn _, v1, v2 -> v1 + v2 end)
        |> count_wins(p1_wins, p2_wins)
    end
  end

  def dirac_possibilities(%DState{} = s) do
    %{
      move(s, 3) => 1,
      move(s, 4) => 3,
      move(s, 5) => 6,
      move(s, 6) => 7,
      move(s, 7) => 6,
      move(s, 8) => 3,
      move(s, 9) => 1
    }
  end

  def move(%DState{turn: :p1} = s, die_roll) do
    new_pos =
      case rem(die_roll + s.p1, 10) do
        0 -> 10
        n -> n
      end

    %DState{s | p1: new_pos, p1_score: s.p1_score + new_pos, turn: :p2}
  end

  def move(%DState{turn: :p2} = s, die_roll) do
    new_pos =
      case rem(die_roll + s.p2, 10) do
        0 -> 10
        n -> n
      end

    %DState{s | p2: new_pos, p2_score: s.p2_score + new_pos, turn: :p1}
  end
end
