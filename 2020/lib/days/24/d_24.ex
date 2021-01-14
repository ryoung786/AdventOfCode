defmodule Aoc2020.Days.D_24 do
  use Aoc2020.Days.Base
  require Integer

  @impl true
  def part_one(str), do: {"Part 1:", str |> input_to_grid() |> Enum.count()}

  @impl true
  def part_two(str), do: {"Part 2:", str |> input_to_grid() |> do_n_days(100) |> Enum.count()}

  def input_to_grid(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&str_to_xy/1)
    |> Enum.frequencies()
    |> Enum.map(fn {xy, v} -> {xy, rem(v, 2)} end)
    |> filter_out_white_tiles()
    |> Enum.into(%{})
  end

  def filter_out_white_tiles(grid), do: grid |> Enum.reject(fn {_k, v} -> v == 0 end)

  def str_to_xy(str, xy \\ {0, 0})
  def str_to_xy("", xy), do: xy
  def str_to_xy("e" <> str, {x, y}), do: str_to_xy(str, {x + 2, y})
  def str_to_xy("w" <> str, {x, y}), do: str_to_xy(str, {x - 2, y})
  def str_to_xy("ne" <> str, {x, y}), do: str_to_xy(str, {x + 1, y + 1})
  def str_to_xy("se" <> str, {x, y}), do: str_to_xy(str, {x + 1, y - 1})
  def str_to_xy("nw" <> str, {x, y}), do: str_to_xy(str, {x - 1, y + 1})
  def str_to_xy("sw" <> str, {x, y}), do: str_to_xy(str, {x - 1, y - 1})

  def do_n_days(grid, 0), do: grid
  def do_n_days(grid, n), do: grid |> next_day() |> do_n_days(n - 1)

  def next_day(grid) do
    grid
    |> expand_grid
    |> Enum.map(fn {xy, v} -> {xy, maybe_flip(grid, xy, v)} end)
    |> filter_out_white_tiles()
    |> Enum.into(%{})
  end

  def maybe_flip(grid, xy, 1) do
    case count_neighbors(grid, xy) do
      0 -> 0
      n when n > 2 -> 0
      _ -> 1
    end
  end

  def maybe_flip(grid, xy, 0), do: if(count_neighbors(grid, xy) == 2, do: 1, else: 0)

  def expand_grid(grid) do
    grid
    |> Enum.reduce(MapSet.new(), fn {xy, _v}, set -> MapSet.union(set, neighbor_coords(xy)) end)
    |> Enum.reduce(grid, fn xy, grid -> Map.put_new(grid, xy, 0) end)
  end

  def count_neighbors(grid, {x, y}),
    do: neighbor_coords({x, y}) |> Enum.map(&Map.get(grid, &1, 0)) |> Enum.sum()

  def neighbor_coords({x, y}) do
    MapSet.new([
      {x + 2, y},
      {x - 2, y},
      {x + 1, y + 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y - 1}
    ])
  end
end
