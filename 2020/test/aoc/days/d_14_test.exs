defmodule Aoc.Days.D_14_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_14

  setup_all do
    %{
      part1: """
      mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      mem[8] = 11
      mem[7] = 101
      mem[8] = 0
      """,
      part2: """
      mask = 000000000000000000000000000000X1001X
      mem[42] = 100
      mask = 00000000000000000000000000000000X0XX
      mem[26] = 1
      """
    }
  end

  test "part 1", %{part1: str} do
    assert {_, 165} = part_one(str)
  end

  test "apply mask" do
    val = 42
    mask = "000000000000000000000000000000X1001X"
    assert apply_mask(val, mask, true) == String.pad_leading("0X1101X", 36, "0")
  end

  test "all_vals" do
    assert all_vals("0000001X0XX") |> MapSet.new() == MapSet.new([16, 17, 18, 19, 24, 25, 26, 27])
    assert all_vals("0X1101X") |> MapSet.new() == MapSet.new([26, 27, 58, 59])
  end

  test "part 2", %{part2: str} do
    assert {_, 208} = part_two(str)
  end
end
