defmodule Aoc.Year2019.Day05 do
  use Aoc.DayBase

  @impl true
  def part_one(str) do
    {:ok, vm} = str |> Input.to_intcode_program() |> Intcode.new([1])
    %{output: [diagnostic_code | _]} = Intcode.run_sync(vm)
    diagnostic_code
  end

  @impl true
  def part_two(str) do
    {:ok, vm} = str |> Input.to_intcode_program() |> Intcode.new([5])
    %{output: [diagnostic_code | _]} = Intcode.run_sync(vm)
    diagnostic_code
  end
end
