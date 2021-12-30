defmodule Aoc.Year2021.Day20Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day20

  setup_all do
    input = """
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
    """

    {:ok, input: input}
  end

  describe "2021 Day 20" do
    test "part one", %{input: input} do
      assert part_one(input) == 35
    end

    test "enhanced pixel", %{input: input} do
      {algo, img} = parse_input(input)
      assert calc_index(img, 2, 2) == 34
      assert enhanced_pixel(algo, img, 2, 2) == "#"

      assert enhanced_pixel(algo, pad(img, 2), 1, 1) == "."
      assert enhanced_pixel(algo, pad(img, 2), 5, 2) == "."
    end

    # slow
    # test "part two", %{input: input} do
    #   assert part_two(input) == 3351
    # end
  end
end
