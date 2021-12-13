defmodule Aoc.Year2019.Day09 do
  use Aoc.DayBase

  @impl true
  def part_one(str), do: str |> Input.to_intcode_program() |> run_boost(:test)

  @impl true
  def part_two(str), do: str |> Input.to_intcode_program() |> run_boost(:sensor_boost)

  def run_boost(prog, mode) do
    input_val = %{test: 1, sensor_boost: 2} |> Map.get(mode)

    {:ok, vm} = Intcode.new(prog, [input_val])
    %{output: [result | _]} = Intcode.run_sync(vm)
    result
  end
end
