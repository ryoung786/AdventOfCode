defmodule Aoc2020.Days.D_13_Test do
  use ExUnit.Case, async: true
  import Aoc2020.Days.D_13

  setup_all do
    %{
      input: """
      939
      7,13,x,x,59,x,31,19
      """
    }
  end

  test("part 1", %{input: str}, do: assert({_, 295} = part_one(str)))

  test "part 2" do
    assert {_, 1_068_781} = part_two("0\n7,13,x,x,59,x,31,19")
    assert {_, 3417} = part_two("0\n17,x,13,19")
    assert {_, 754_018} = part_two("0\n67,7,59,61")
    assert {_, 779_210} = part_two("0\n67,x,7,59,61")
    assert {_, 1_261_476} = part_two("0\n67,7,x,59,61")
    assert {_, 1_202_161_486} = part_two("0\n1789,37,47,1889")
  end
end
