defmodule Aoc.Days.D_22_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_22

  setup_all do
    %{
      str: """
      Player 1:
      9
      2
      6
      3
      1

      Player 2:
      5
      8
      4
      7
      10
      """,
      infinite: """
      Player 1:
      43
      19

      Player 2:
      2
      29
      14
      """
    }
  end

  test "winning score calculation", %{str: input} do
    assert winning_score([3, 2, 10, 6, 8, 5, 9, 4, 7, 1]) == 306
  end

  test "part 1", %{str: input} do
    assert {_, 306} = part_one(input)
  end

  test "infinite check", %{infinite: input} do
    [p1, p2] = parse_input(input)
    assert {:p1, _} = play_to_end2(p1, p2)
  end

  test "part 2", %{str: input} do
    assert {_, 291} = part_two(input)
  end
end
