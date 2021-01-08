defmodule IntcodeTest do
  use ExUnit.Case

  def to_map(lst), do: lst |> Enum.with_index() |> Enum.map(fn {v, i} -> {i, v} end) |> Map.new()

  def run(prog) do
    {:ok, vm} = Intcode.new(prog)
    Intcode.run_sync(vm) |> Map.get(:memory)
  end

  test "intro" do
    assert run([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]) ==
             to_map([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50])

    assert run([1, 0, 0, 0, 99]) == to_map([2, 0, 0, 0, 99])
    assert run([2, 3, 0, 3, 99]) == to_map([2, 3, 0, 6, 99])
    assert run([2, 4, 4, 5, 99, 0]) == to_map([2, 4, 4, 5, 99, 9801])
    assert run([1, 1, 1, 4, 99, 5, 6, 0, 99]) == to_map([30, 1, 1, 4, 2, 5, 6, 0, 99])
  end

  test "param_modes" do
    assert run([1002, 4, 3, 4, 33]) == to_map([1002, 4, 3, 4, 99])
    assert run([1101, 100, -1, 4, 0]) == to_map([1101, 100, -1, 4, 99])
  end

  test "equals 8, position mode" do
    prog = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
    {:ok, vm} = Intcode.new(prog, [3])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [0]

    {:ok, vm} = Intcode.new(prog, [8])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [1]
  end

  test "equals 8, immediate mode" do
    prog = [3, 3, 1108, -1, 8, 3, 4, 3, 99]
    {:ok, vm} = Intcode.new(prog, [3])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [0]

    {:ok, vm} = Intcode.new(prog, [8])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [1]
  end

  test "less than 8, position mode" do
    prog = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
    {:ok, vm} = Intcode.new(prog, [3])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [1]

    {:ok, vm} = Intcode.new(prog, [18])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [0]
  end

  test "less than 8, immediate mode" do
    prog = [3, 3, 1107, -1, 8, 3, 4, 3, 99]
    {:ok, vm} = Intcode.new(prog, [3])
    Intcode.input(vm, 3)
    assert Intcode.run_sync(vm) |> Map.get(:output) == [1]

    {:ok, vm} = Intcode.new(prog, [18])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [0]
  end

  test "jump, position mode" do
    prog = [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]
    {:ok, vm} = Intcode.new(prog, [0])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [0]

    {:ok, vm} = Intcode.new(prog, [4])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [1]
  end

  test "jump, immediate mode" do
    prog = [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]
    {:ok, vm} = Intcode.new(prog, [0])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [0]

    {:ok, vm} = Intcode.new(prog, [4])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [1]
  end

  test "compare to 8" do
    prog =
      """
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
      """
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    {:ok, vm} = Intcode.new(prog, [4])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [999]
    {:ok, vm} = Intcode.new(prog, [8])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [1000]
    {:ok, vm} = Intcode.new(prog, [39])
    assert Intcode.run_sync(vm) |> Map.get(:output) == [1001]
  end
end
