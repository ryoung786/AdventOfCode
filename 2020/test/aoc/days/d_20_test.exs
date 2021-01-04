defmodule Aoc.Days.D_20_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_20

  setup_all do
    %{
      str: """
      Tile 2311:
      ..##.#..#.
      ##..#.....
      #...##..#.
      ####.#...#
      ##.##.###.
      ##...#.###
      .#.#.#..##
      ..#....#..
      ###...#.#.
      ..###..###

      Tile 1951:
      #.##...##.
      #.####...#
      .....#..##
      #...######
      .##.#....#
      .###.#####
      ###.##.##.
      .###....#.
      ..#.#..#.#
      #...##.#..

      Tile 1171:
      ####...##.
      #..##.#..#
      ##.#..#.#.
      .###.####.
      ..###.####
      .##....##.
      .#...####.
      #.##.####.
      ####..#...
      .....##...

      Tile 1427:
      ###.##.#..
      .#..#.##..
      .#.##.#..#
      #.#.#.##.#
      ....#...##
      ...##..##.
      ...#.#####
      .#.####.#.
      ..#..###.#
      ..##.#..#.

      Tile 1489:
      ##.#.#....
      ..##...#..
      .##..##...
      ..#...#...
      #####...#.
      #..#.#.#.#
      ...#.#.#..
      ##.#...##.
      ..##.##.##
      ###.##.#..

      Tile 2473:
      #....####.
      #..#.##...
      #.##..#...
      ######.#.#
      .#...#.#.#
      .#########
      .###.#..#.
      ########.#
      ##...##.#.
      ..###.#.#.

      Tile 2971:
      ..#.#....#
      #...###...
      #.#.###...
      ##.##..#..
      .#####..##
      .#..####.#
      #..#.#..#.
      ..####.###
      ..#.#.###.
      ...#.#.#.#

      Tile 2729:
      ...#.#.#.#
      ####.#....
      ..#.#.....
      ....#..#.#
      .##..##.#.
      .#.####...
      ####.#.#..
      ##.####...
      ##..#.##..
      #.##...##.

      Tile 3079:
      #.#.#####.
      .#..######
      ..#.......
      ######....
      ####.#..#.
      .#...#.##.
      #.#####.##
      ..#.###...
      ..#.......
      ..#.###...
      """
    }
  end

  test "part 1", %{str: input} do
    # tiles = parse_into_tiles(input)
    # assert Enum.count(tiles) == 9
    # assert get_tile_ids_that_have_edge("..##.#..#.", tiles) |> set() == set([2311, 1427])
    # assert get_tile_ids_that_have_edge("#.#.##...#", tiles) |> set() == set([2971, 1489])
    # assert tiles_to_corner_ids(tiles) == MapSet.new([1951, 2971, 3079, 1171])
    assert {_, 20_899_048_083_289} = part_one(input)
  end

  # defp set(lst), do: MapSet.new(lst)

  # defp tiles_to_corner_ids(tiles),
  #   do: tiles |> populate_neighbors() |> get_corner_tile_ids() |> MapSet.new()

  test "part 2", %{str: input} do
    grid =
      input
      |> parse_into_tiles()
      |> solve_puzzle()
      |> merge_puzzle()

    assert grid |> to_rows() |> to_grid == grid

    assert {_, 273} = part_two(input)
  end
end
