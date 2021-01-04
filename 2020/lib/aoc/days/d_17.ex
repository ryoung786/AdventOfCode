defmodule Aoc.Days.D_17 do
  use Aoc.Days.Base

  @atoms %{"." => :off, "#" => :on}

  @impl true
  def part_one(str) do
    {"Part 1:",
     str
     |> str_to_grid()
     |> run(6)
     |> count_occupied()}
  end

  @impl true
  def part_two(str) do
    {"Part 2:",
     str
     |> str_to_grid2()
     |> run2(6)
     |> count_occupied()}
  end

  def str_to_grid(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, grid ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce(grid, fn {ch, x}, acc -> Map.put(acc, {x, y, 0}, @atoms[ch]) end)
    end)
  end

  def count_occupied(grid) do
    grid |> Map.values() |> Enum.count(&(&1 == :on))
  end

  def run(grid, 0), do: grid

  def run(grid, turns) do
    {xr, yr, zr} = bbox(grid)

    next =
      for x <- xr, y <- yr, z <- zr, into: %{} do
        xyz = {x, y, z}
        {xyz, flip(grid, xyz, Map.get(grid, xyz))}
      end

    run(next, turns - 1)
  end

  def flip(grid, xyz, :on), do: if(count_neighbors(grid, xyz) in [2, 3], do: :on, else: :off)
  def flip(grid, xyz, _), do: if(count_neighbors(grid, xyz) == 3, do: :on, else: :off)

  def count_neighbors(grid, {x, y, z}) do
    for i <- -1..1, j <- -1..1, k <- -1..1, reduce: 0 do
      acc ->
        if {i, j, k} != {0, 0, 0} and Map.get(grid, {x + i, y + j, z + k}) == :on,
          do: acc + 1,
          else: acc
    end
  end

  def bbox(grid) do
    keys = Map.keys(grid)

    {{xa, _, _}, {xb, _, _}} = Enum.min_max_by(keys, fn {x, _, _} -> x end)
    {{_, ya, _}, {_, yb, _}} = Enum.min_max_by(keys, fn {_, y, _} -> y end)
    {{_, _, za}, {_, _, zb}} = Enum.min_max_by(keys, fn {_, _, z} -> z end)

    {(xa - 1)..(xb + 1), (ya - 1)..(yb + 1), (za - 1)..(zb + 1)}
  end

  def str_to_grid2(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, grid ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce(grid, fn {ch, x}, acc -> Map.put(acc, {x, y, 0, 0}, @atoms[ch]) end)
    end)
  end

  def run2(grid, 0), do: grid

  def run2(grid, turns) do
    {wr, xr, yr, zr} = bbox2(grid)

    next =
      for w <- wr, x <- xr, y <- yr, z <- zr, into: %{} do
        wxyz = {w, x, y, z}
        {wxyz, flip2(grid, wxyz, Map.get(grid, wxyz))}
      end

    run2(next, turns - 1)
  end

  def flip2(grid, wxyz, :on), do: if(count_neighbors2(grid, wxyz) in [2, 3], do: :on, else: :off)
  def flip2(grid, wxyz, _), do: if(count_neighbors2(grid, wxyz) == 3, do: :on, else: :off)

  def count_neighbors2(grid, {w, x, y, z}) do
    for i <- -1..1, j <- -1..1, k <- -1..1, l <- -1..1, reduce: 0 do
      acc ->
        if {i, j, k, l} != {0, 0, 0, 0} and Map.get(grid, {w + i, x + j, y + k, z + l}) == :on,
          do: acc + 1,
          else: acc
    end
  end

  def bbox2(grid) do
    keys = Map.keys(grid)

    {{wa, _, _, _}, {wb, _, _, _}} = Enum.min_max_by(keys, fn {w, _, _, _} -> w end)
    {{_, xa, _, _}, {_, xb, _, _}} = Enum.min_max_by(keys, fn {_, x, _, _} -> x end)
    {{_, _, ya, _}, {_, _, yb, _}} = Enum.min_max_by(keys, fn {_, _, y, _} -> y end)
    {{_, _, _, za}, {_, _, _, zb}} = Enum.min_max_by(keys, fn {_, _, _, z} -> z end)

    {(wa - 1)..(wb + 1), (xa - 1)..(xb + 1), (ya - 1)..(yb + 1), (za - 1)..(zb + 1)}
  end
end
