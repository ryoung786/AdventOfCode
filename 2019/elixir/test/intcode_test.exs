defmodule IntcodeTest do
  use ExUnit.Case
  import Intcode

  def to_map(lst), do: lst |> Enum.with_index() |> Enum.map(fn {v, i} -> {i, v} end) |> Map.new()

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
end
