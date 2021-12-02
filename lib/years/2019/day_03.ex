defmodule Aoc.Year2019.Day03 do
  use Aoc.DayBase
  import Enum

  @impl true
  def part_one(str) do
    [w1, w2] = str |> parse_input()
    all_intersections(w1, w2) |> map(&manhattan_distance/1) |> min()
  end

  @impl true
  def part_two(str) do
    [w1, w2] = str |> parse_input()
    all_intersections(w1, w2) |> map(&segment_length(&1, w1, w2)) |> min()
  end

  def parse_input(str) do
    str |> Input.to_str_list() |> map(&String.split(&1, ",")) |> map(&to_wire/1)
  end

  defp to_wire(lst) do
    lst
    |> reduce([%{xy: {0, 0}}], fn n, [%{xy: {x, y}} | _] = acc ->
      {dx, dy} = parse_vector(n)
      magnitude = [abs(dx), abs(dy)] |> max()

      segment = %{
        xs: x..(x + dx),
        ys: y..(y + dy),
        prev: {x, y},
        xy: {x + dx, y + dy},
        magnitude: magnitude
      }

      [segment | acc]
    end)
    |> reverse()
    |> drop(1)
  end

  defp parse_vector("R" <> magnitude), do: {String.to_integer(magnitude), 0}
  defp parse_vector("L" <> magnitude), do: {-String.to_integer(magnitude), 0}
  defp parse_vector("U" <> magnitude), do: {0, String.to_integer(magnitude)}
  defp parse_vector("D" <> magnitude), do: {0, -String.to_integer(magnitude)}

  def all_intersections(w1, w2) do
    for a <- w1, b <- w2, intersect?(a, b) do
      case a.xs do
        x..x ->
          y..y = b.ys
          {x, y}

        _ ->
          x.._ = b.xs
          y.._ = a.ys
          {x, y}
      end
    end
    |> reject(fn {x, y} -> {x, y} == {0, 0} end)
  end

  defp intersect?(a, b) do
    !Range.disjoint?(a.xs, b.xs) and !Range.disjoint?(a.ys, b.ys)
  end

  defp manhattan_distance({x, y}), do: abs(x) + abs(y)

  defp segment_length(pt, w1, w2), do: seg_length(pt, w1) + seg_length(pt, w2)

  defp seg_length({x, y}, wire) do
    wire
    |> reduce_while(0, fn seg, sum ->
      if x in seg.xs and y in seg.ys do
        {prev_x, prev_y} = seg.prev
        {:halt, sum + abs(x - prev_x) + abs(y - prev_y)}
      else
        {:cont, sum + seg.magnitude}
      end
    end)
  end
end
