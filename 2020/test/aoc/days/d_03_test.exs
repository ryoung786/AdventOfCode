defmodule Aoc.Days.D_03_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_03

  setup_all do
    %{
      str: """
      ..##.......
      #...#...#..
      .#....#..#.
      ..#.#...#.#
      .#...##..#.
      ..#.##.....
      .#.#.#....#
      .#........#
      #.##...#...
      #...##....#
      .#..#...#.#
      """
    }
  end

  test "part a", %{str: str} do
    arr = parse_input_str(str)
    assert count_collisions_with_slope(arr, 1, 3) == 7
  end

  test "part b, multiple slopes", %{str: str} do
    arr = parse_input_str(str)
    assert count_collisions_with_slope(arr, 1, 1) == 2
    assert count_collisions_with_slope(arr, 1, 3) == 7
    assert count_collisions_with_slope(arr, 1, 5) == 3
    assert count_collisions_with_slope(arr, 1, 7) == 4
    assert count_collisions_with_slope(arr, 2, 1) == 2

    assert {_, 336} = part_two(str)
  end
end
