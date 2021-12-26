defmodule Aoc.Utils.Matrix do
  alias __MODULE__, as: Matrix
  defstruct m: [], w: 0, h: 0

  def from_string(str), do: from_string(str, &String.to_integer/1)

  def from_string(str, mapping_function) do
    m =
      str
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split("", trim: true) |> Enum.map(fn ch -> mapping_function.(ch) end)
      end)

    h = Enum.count(m)
    w = if h == 0, do: 0, else: Enum.count(hd(m))
    %Matrix{m: m, w: w, h: h}
  end

  def at(%Matrix{} = m, {x, y}), do: at(m, x, y)

  def at(%Matrix{m: m, w: w, h: h}, x, y) when x >= 0 and x < w and y >= 0 and y < h do
    row = Enum.at(m, y)
    Enum.at(row, x)
  end

  # out of bounds
  def at(%Matrix{}, _x, _y), do: nil

  def neighbors(%Matrix{} = m, {x, y}), do: neighbors(m, x, y)

  def neighbors(%Matrix{w: w, h: h} = m, x, y) when x >= 0 and x < w and y >= 0 and y < h do
    [up: {0, -1}, down: {0, 1}, left: {-1, 0}, right: {1, 0}]
    |> Enum.map(fn {_dir, {dx, dy}} -> {{x + dx, y + dy}, at(m, x + dx, y + dy)} end)
    |> Enum.reject(fn {_pos, val} -> is_nil(val) end)
    |> Enum.into(%{})
  end

  def all_neighbors(%Matrix{} = m, {x, y}), do: all_neighbors(m, x, y)

  def all_neighbors(%Matrix{w: w, h: h} = m, x, y) when x >= 0 and x < w and y >= 0 and y < h do
    for(
      dx <- -1..1,
      dy <- -1..1,
      do: {x + dx, y + dy}
    )
    |> Enum.reject(fn xy -> xy == {x, y} end)
    |> Enum.map(fn xy -> {xy, at(m, xy)} end)
    |> Enum.reject(fn {_pos, val} -> is_nil(val) end)
    |> Enum.into(%{})
  end

  def with_xy(%Matrix{} = m) do
    new =
      m.m
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {val, x} -> {{x, y}, val} end)
      end)

    %Matrix{m: new, w: m.w, h: m.h}
  end

  def map(%Matrix{} = m, f) do
    new =
      m.m
      |> Enum.map(fn row ->
        Enum.map(row, fn val -> f.(val) end)
      end)

    %Matrix{m: new, w: m.w, h: m.h}
  end

  def count(%Matrix{m: m}, f) do
    m
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, y}, total ->
      total + Enum.count(Enum.with_index(row), fn {val, x} -> f.(x, y, val) end)
    end)
  end

  def filter(%Matrix{} = m, f) do
    m.m
    |> Enum.flat_map(fn row ->
      Enum.filter(row, fn val -> f.(val) end)
    end)
  end

  def update(%Matrix{} = m, x, y, f) do
    map(Matrix.with_xy(m), fn
      {{^x, ^y}, curr_val} -> f.(curr_val)
      {{_x, _y}, val} -> val
    end)
  end

  def put(%Matrix{} = m, x, y, new_val) do
    update(m, x, y, fn _ -> new_val end)
  end

  def put(%Matrix{} = m, map) do
    Enum.reduce(map, m, fn {{x, y}, val}, acc ->
      Matrix.put(acc, x, y, val)
    end)
  end
end

defimpl Inspect, for: Aoc.Utils.Matrix do
  alias Aoc.Utils.Matrix

  def inspect(%Matrix{} = m, _opts) do
    "width: #{m.w}, height: #{m.h}\n" <>
      (m.m
       |> Enum.map(fn row ->
         Enum.join(row, " ")
       end)
       |> Enum.join("\n"))
  end
end
