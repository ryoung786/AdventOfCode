defmodule Aoc.Year2020.Day13 do
  use Aoc.DayBase

  defp parse_input_str(str) do
    [arrival, bus_ids_str] = str |> Input.to_str_list()

    {arrival |> String.to_integer(),
     bus_ids_str
     |> String.split(",")
     |> Enum.with_index()
     |> Enum.filter(fn {id, _i} -> id != "x" end)
     |> Enum.map(fn {id, i} -> {String.to_integer(id), i} end)}
  end

  @impl true
  def part_one(str) do
    {arrival, bus_ids} = str |> parse_input_str()

    {bus_id, time} =
      bus_ids
      |> Enum.map(fn {id, _i} -> {id, arrival - rem(arrival, id) + id} end)
      |> Enum.min_by(fn {_bus_id, val} -> val end)

    bus_id * (time - arrival)
  end

  @impl true
  def part_two(str), do: parse_input_str(str) |> elem(1) |> calculate_time()

  def calculate_time(bus_ids) do
    bus_ids
    |> Enum.reduce({1, 1}, fn {b, offset}, {a, cycle} ->
      {f(a, b, offset, a, cycle), cycle * b}
    end)
    |> elem(0)
  end

  def f(_a, b, offset, t, _w) when rem(t + offset, b) == 0, do: t
  def f(a, b, offset, t, w), do: f(a, b, offset, t + w, w)
end
