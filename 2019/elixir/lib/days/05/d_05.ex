defmodule Days.D_05 do
  use Days.Base
  import Enum

  @impl true
  def part_one(str) do
    {:ok, vm} = str |> Util.to_intcode_program() |> Intcode.new()
    Intcode.input(vm, 1)
    %{output: [diagnostic_code | _output]} = Intcode.run_sync(vm)
    diagnostic_code
  end

  @impl true
  def part_two(str) do
  end
end
