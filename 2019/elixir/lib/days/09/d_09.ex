defmodule Days.D_09 do
  use Days.Base

  @impl true
  def part_one(str) do
    str |> Util.to_intcode_program() |> boost_keycode()
  end

  @impl true
  def part_two(str) do
    # str |> Util.to_intcode_program() |> boost_keycode()
  end

  def boost_keycode(prog) do
    {:ok, vm} = Intcode.new(prog, [1])
    state = Intcode.run_sync(vm) |> IO.inspect(label: "[state] ")
    state.output
  end
end
