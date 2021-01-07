defmodule Days.D_02 do
  use Days.Base
  import Enum

  @impl true
  def part_one(str) do
    str
    |> parse_input()
    |> attempt(12, 2)
  end

  @impl true
  def part_two(str) do
    mem = str |> parse_input()

    {n, v} =
      all_permutations()
      |> find(fn {n, v} -> attempt(mem, n, v) == 19_690_720 end)

    n * 100 + v
  end

  def parse_input(str) do
    str |> String.trim() |> String.split(",", trim: true) |> map(&String.to_integer/1)
  end

  defp all_permutations() do
    for noun <- 0..99,
        verb <- 0..99 do
      {noun, verb}
    end
  end

  def attempt(mem, noun, verb) do
    mem
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> Intcode.run()
    |> Map.get(0)
  end
end
