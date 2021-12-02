defmodule Aoc.Year2020.Day20 do
  use Aoc.DayBase

  @sm [
    {18, 0},
    {0, 1},
    {5, 1},
    {6, 1},
    {11, 1},
    {12, 1},
    {17, 1},
    {18, 1},
    {19, 1},
    {1, 2},
    {4, 2},
    {7, 2},
    {10, 2},
    {13, 2},
    {16, 2}
  ]

  @impl true
  def part_one(str) do
    str
    |> parse_into_tiles()
    |> solve_puzzle()
    |> corner_ids()
    |> Enum.reduce(&(&1 * &2))
  end

  @impl true
  def part_two(str) do
    str
    |> parse_into_tiles()
    |> solve_puzzle()
    |> merge_puzzle()
    |> mark_sea_monsters()
    |> count_water_roughness()
  end

  def parse_into_tiles(str) do
    # id => rows of chars
    str
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(%{}, fn tile_str, m ->
      [title | rows] = tile_str |> String.split("\n", trim: true)
      id = Regex.run(~r/Tile (\d+):/, title) |> Enum.at(1) |> String.to_integer()
      Map.put(m, id, rows |> Enum.map(&String.graphemes/1))
    end)
  end

  def corner_ids(puzzle) do
    len = puzzle |> Enum.map(fn {{x, _y}, _tile} -> x end) |> Enum.max()

    [
      Map.get(puzzle, {0, 0}),
      Map.get(puzzle, {0, len}),
      Map.get(puzzle, {len, 0}),
      Map.get(puzzle, {len, len})
    ]
    |> Enum.map(fn {id, _} -> id end)
  end

  def solve_puzzle(rem_tiles, placed \\ %{}, curr \\ {0, 0}, dir \\ :east)
  def solve_puzzle(rem_tiles, placed, _curr, _dir) when rem_tiles == %{}, do: re_center(placed)

  def solve_puzzle(rem_tiles, placed, {0, 0}, dir) when placed == %{} do
    tile_id = rem_tiles |> Map.keys() |> hd()
    tile = rem_tiles[tile_id]
    solve_puzzle(Map.delete(rem_tiles, tile_id), %{{0, 0} => {tile_id, tile}}, {0, 0}, dir)
  end

  def solve_puzzle(rem_tiles, placed, curr, dir) do
    {_, curr_tile} = placed[curr]

    case find_matching_tile(get_edge(curr_tile, dir), flip_dir(dir), rem_tiles) do
      nil ->
        {_, dir} = next_nomatch(curr, dir)
        solve_puzzle(rem_tiles, placed, curr, dir)

      {id, tile} ->
        {curr, dir} = next_xy(curr, dir)
        solve_puzzle(Map.delete(rem_tiles, id), Map.put(placed, curr, {id, tile}), curr, dir)
    end
  end

  def next_xy({x, y}, :east), do: {{x + 1, y}, :east}
  def next_xy({x, y}, :west), do: {{x - 1, y}, :west}
  def next_xy({x, y}, :north), do: {{x, y - 1}, :north}
  def next_xy({x, y}, :south), do: {{x, y + 1}, :south}
  def next_nomatch(xy, :east), do: next_xy(xy, :south)
  def next_nomatch(xy, :south), do: next_xy(xy, :west)
  def next_nomatch(xy, :west), do: next_xy(xy, :north)
  def next_nomatch(xy, :north), do: next_xy(xy, :east)
  def flip_dir(:east), do: :west
  def flip_dir(:west), do: :east
  def flip_dir(:north), do: :south
  def flip_dir(:south), do: :north

  def get_edge(rows, :north), do: hd(rows)
  def get_edge(rows, :south), do: List.last(rows)
  def get_edge(rows, :east), do: rows |> Enum.zip() |> List.last() |> Tuple.to_list()
  def get_edge(rows, :west), do: rows |> Enum.zip() |> hd() |> Tuple.to_list()

  def find_matching_tile(edge, target_dir, tiles) do
    tiles
    |> Enum.find_value(fn tile -> match(edge, target_dir, tile) end)
  end

  def match(edge, target_dir, tile, rot \\ 8)
  def match(_edge, _target_dir, _tile, -1), do: nil

  def match(edge, target_dir, {id, rows}, 4),
    do: match(edge, target_dir, {id, Enum.reverse(rows)}, 3)

  def match(edge, target_dir, {id, rows}, rot) do
    if edge == get_edge(rows, target_dir),
      do: {id, rows},
      else: match(edge, target_dir, {id, rotate(rows)}, rot - 1)
  end

  def rotate(rows),
    do: rows |> Enum.zip() |> Enum.map(fn tup -> tup |> Tuple.to_list() |> Enum.reverse() end)

  def re_center(puzzle) do
    dx = puzzle |> Enum.map(fn {{x, _y}, _val} -> x end) |> Enum.min()
    dy = puzzle |> Enum.map(fn {{_x, y}, _val} -> y end) |> Enum.min()
    puzzle |> Enum.map(fn {{x, y}, val} -> {{x - dx, y - dy}, val} end) |> Map.new()
  end

  def merge_puzzle(puzzle) do
    puzzle = puzzle |> remove_borders()
    puzzle_len = puzzle |> Enum.count(fn {{x, _y}, _tile} -> x == 0 end)
    tile_len = puzzle |> Map.get({0, 0}) |> Enum.count()

    puzzle =
      puzzle
      |> Enum.map(fn {xy, tile} -> {xy, to_grid(tile)} end)
      |> Map.new()

    for y <- 0..(puzzle_len - 1), x <- 0..(puzzle_len - 1), reduce: %{} do
      acc ->
        add_to_map(acc, Map.get(puzzle, {x, y}), x * tile_len, y * tile_len)
    end
  end

  def add_to_map(acc, m, dx, dy),
    do: m |> Enum.map(fn {{x, y}, v} -> {{x + dx, y + dy}, v} end) |> Map.new() |> Map.merge(acc)

  def to_grid(rows) do
    rows
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, m ->
      row
      |> Enum.with_index()
      |> Enum.reduce(m, fn {ch, x}, m -> Map.put(m, {x, y}, ch) end)
    end)
  end

  def to_rows(grid) do
    x_max = grid |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    y_max = grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    for y <- 0..y_max, reduce: [] do
      rows ->
        row = Enum.reduce(0..x_max, [], fn x, row -> row ++ [Map.get(grid, {x, y})] end)
        rows ++ [row]
    end
  end

  def remove_borders(puzzle) do
    puzzle
    |> Enum.map(fn {xy, {_id, rows}} ->
      {xy,
       rows
       |> Enum.slice(1..(Enum.count(rows) - 2))
       |> Enum.map(fn row -> Enum.slice(row, 1..(Enum.count(row) - 2)) end)}
    end)
    |> Map.new()
  end

  def mark_sea_monsters(img, orientation \\ 8)

  def mark_sea_monsters(img, 4),
    do: mark_sea_monsters(img |> to_rows() |> Enum.reverse() |> to_grid(), 3)

  def mark_sea_monsters(img, orientation) do
    marked = img |> Enum.reduce(img, fn {xy, _v}, img -> maybe_mark_sea_moster(img, xy) end)

    case marked |> Map.values() |> Enum.count(&(&1 == "O")) do
      0 -> mark_sea_monsters(img |> to_rows() |> rotate() |> to_grid(), orientation - 1)
      _ -> marked
    end
  end

  def count_water_roughness(marked), do: marked |> Map.values() |> Enum.count(&(&1 == "#"))

  def maybe_mark_sea_moster(img, xy),
    do: if(is_sea_monster(img, xy), do: mark_sea_monster(img, xy), else: img)

  def is_sea_monster(img, {x, y}) do
    @sm |> Enum.all?(fn {dx, dy} -> Map.get(img, {x + dx, y + dy}) == "#" end)
  end

  def mark_sea_monster(img, {x, y}),
    do: @sm |> Enum.reduce(img, fn {dx, dy}, img -> Map.put(img, {x + dx, y + dy}, "O") end)
end
