defmodule Aoc.Days.D_25 do
  use Aoc.Days.Base

  def parse_input(str),
    do: str |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)

  @impl true
  def part_one(str) do
    [card_pub, door_pub] = parse_input(str)
    door_loop_size = find_loop_size(7, door_pub)
    enc_key = transform(card_pub, door_loop_size)
    {"Part 1:", enc_key}
  end

  @impl true
  def part_two(_str), do: {"Part 2:", "Party time!"}

  def transform(subj, loop, val \\ 1)
  def transform(_subj, 0, val), do: val
  def transform(subj, loop, val), do: transform(subj, loop - 1, rem(val * subj, 20_201_227))

  def find_loop_size(subj, target, test_loop_size \\ 0, prev \\ 1)

  def find_loop_size(subj, target, test_loop_size, prev) do
    case rem(prev * subj, 20_201_227) do
      ^target -> test_loop_size + 1
      n -> find_loop_size(subj, target, test_loop_size + 1, n)
    end
  end
end
