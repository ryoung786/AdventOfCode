defmodule Aoc2020.Days.D_12_Test do
  use ExUnit.Case, async: true
  import Aoc2020.Days.D_12

  setup_all do
    %{
      input: """
      F10
      N3
      F7
      R90
      F11
      """
    }
  end

  test "input parsing" do
    assert {"F", 10} = parse_line("F10")
    assert {"N", 3} = parse_line("N3")
  end

  test("part 1", %{input: str}, do: assert({_, 25} = part_one(str)))
  test("part 2", %{input: str}, do: assert({_, 286} = part_two(str)))
end
