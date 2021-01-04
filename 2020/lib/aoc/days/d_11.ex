defmodule Aoc.Days.D_11 do
  use Aoc.Days.Base

  @atoms %{"." => :floor, "L" => :empty, "#" => :occupied}

  def parse_input_str(str), do: str |> str_to_grid()

  @impl true
  def part_one(str),
    do: {"Occupied seats:", str |> parse_input_str() |> num_seated_at_steady_state()}

  @impl true
  def part_two(str) do
    {"Part 2:", str |> parse_input_str() |> num_seated_at_steady_state(:part2)}
  end

  def str_to_grid(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, grid ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce(grid, fn {ch, x}, acc -> Map.put(acc, {x, y}, @atoms[ch]) end)
    end)
  end

  def num_seated_at_steady_state(grid, part \\ :part1),
    do: steady_state(grid, part) |> Enum.count(fn {_, state} -> state == :occupied end)

  def steady_state(grid, part, prev \\ nil)
  def steady_state(grid, _part, prev) when grid == prev, do: grid
  def steady_state(grid, part, _prev), do: grid |> next_round(part) |> steady_state(part, grid)

  def next_round(grid, part \\ :part1) do
    grid
    |> Enum.reduce(grid, fn {{x, y}, state}, next ->
      case state do
        :occupied -> %{next | {x, y} => leave_if_crowded(grid, {x, y}, part)}
        :empty -> %{next | {x, y} => sit_if_not_crowded(grid, {x, y}, part)}
        :floor -> next
      end
    end)
  end

  def sit_if_not_crowded(grid, {x, y}, part) do
    if part == :part2,
      do: if(count_visible_occupied_seats(grid, {x, y}) == 0, do: :occupied, else: :empty),
      else: if(count_occupied_neighbors(grid, {x, y}) == 0, do: :occupied, else: :empty)
  end

  def leave_if_crowded(grid, {x, y}, part) do
    if part == :part2,
      do: if(count_visible_occupied_seats(grid, {x, y}) >= 5, do: :empty, else: :occupied),
      else: if(count_occupied_neighbors(grid, {x, y}) >= 4, do: :empty, else: :occupied)
  end

  def count_occupied_neighbors(grid, {x, y}) do
    [
      Map.get(grid, {x - 1, y - 1}),
      Map.get(grid, {x, y - 1}),
      Map.get(grid, {x + 1, y - 1}),
      Map.get(grid, {x - 1, y}),
      Map.get(grid, {x + 1, y}),
      Map.get(grid, {x - 1, y + 1}),
      Map.get(grid, {x, y + 1}),
      Map.get(grid, {x + 1, y + 1})
    ]
    |> Enum.count(&(&1 == :occupied))
  end

  def n_rounds(grid, 0), do: grid
  def n_rounds(grid, n), do: 1..n |> Enum.reduce(grid, fn _n, acc -> next_round(acc) end)

  def count_visible_occupied_seats(grid, xy) do
    [
      first_visible_seat(grid, xy, -1, -1),
      first_visible_seat(grid, xy, 0, -1),
      first_visible_seat(grid, xy, 1, -1),
      first_visible_seat(grid, xy, -1, 0),
      first_visible_seat(grid, xy, 1, 0),
      first_visible_seat(grid, xy, -1, 1),
      first_visible_seat(grid, xy, 0, 1),
      first_visible_seat(grid, xy, 1, 1)
    ]
    |> Enum.count(&(&1 == :occupied))
  end

  def first_visible_seat(grid, cell, dx, dy, state \\ :floor)
  def first_visible_seat(_, _, _, _, nil), do: nil
  def first_visible_seat(_, _, _, _, state) when state in ~w(occupied empty)a, do: state

  def first_visible_seat(grid, {x, y}, dx, dy, :floor) do
    state = Map.get(grid, {x + dx, y + dy})
    first_visible_seat(grid, {x + dx, y + dy}, dx, dy, state)
  end

  defp dim(grid) do
    Map.keys(grid)
    |> Enum.reduce([[], []], fn {x, y}, [xs, ys] -> [[x | xs], [y | ys]] end)
    |> Enum.map(&Enum.max/1)
  end

  def to_bmp(grid) do
    [width, height] = dim(grid)

    data =
      for y <- 1..height, into: <<>> do
        for x <- 1..width, into: <<>> do
          case grid[{x, y}] do
            :occupied -> <<0::little-size(8), 255::little-size(8), 0::little-size(8)>>
            :empty -> <<0::little-size(8), 0::little-size(8), 255::little-size(8)>>
            :floor -> <<0::little-size(8), 0::little-size(8), 0::little-size(8)>>
          end
        end
      end

    # BMP.save("hello2.bmp", BMP.win2x_header(width, height), data)
    BMP.to_b64(data)
  end
end
