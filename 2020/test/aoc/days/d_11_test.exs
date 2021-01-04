defmodule Aoc.Days.D_11_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_11

  setup_all do
    %{
      input: """
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
      """
    }
  end

  test("part 1", %{input: str}, do: assert({_, 37} = part_one(str)))
  test("part 2", %{input: str}, do: assert({_, 26} = part_two(str)))
end
