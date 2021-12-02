defmodule Aoc.Year2020.Day03Test do
  use ExUnit.Case, async: true
  import Aoc.Year2020.Day03

  setup_all do
    input = """
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

    {:ok, input: input}
  end

  describe "2020 day 3" do
    test "part one", %{input: input} do
      assert part_one(input) == 7
    end

    test "part two", %{input: input} do
      assert part_two(input) == 336
    end
  end
end
