defmodule Aoc.Year2019.Day02 do
  use Aoc.DayBase
  import Enum

  @impl true
  def part_one(str) do
    str
    |> Input.to_intcode_program()
    |> attempt(12, 2)
  end

  @impl true
  def part_two(str) do
    mem = str |> Input.to_intcode_program()

    {n, v} =
      all_permutations()
      |> find(fn {n, v} -> attempt(mem, n, v) == 19_690_720 end)

    n * 100 + v
  end

  defp all_permutations() do
    for noun <- 0..99,
        verb <- 0..99 do
      {noun, verb}
    end
  end

  def attempt(mem, noun, verb) do
    {:ok, vm} =
      mem
      |> List.replace_at(1, noun)
      |> List.replace_at(2, verb)
      |> Intcode.new()

    Intcode.run_sync(vm)
    |> Map.get(:memory)
    |> Map.get(0)
  end
end
