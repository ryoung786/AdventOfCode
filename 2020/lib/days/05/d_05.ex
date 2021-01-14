defmodule Aoc2020.Days.D_05 do
  use Aoc2020.Days.Base

  @impl true
  def part_one(str) do
    seats = str |> Util.str_array() |> Enum.map(&calc_seat_id/1)
    {"Highest seat:", highest_seat(seats)}
  end

  @impl true
  def part_two(str) do
    seats = str |> Util.str_array() |> Enum.map(&calc_seat_id/1)
    {"My seat:", find_missing_seat(seats)}
  end

  def highest_seat(seats), do: Enum.max(seats)

  def calc_seat_id(str) do
    {rows, cols} = String.split_at(str, -3)
    calc(rows) * 8 + calc(cols)
  end

  def calc(str) do
    range = 0..(:math.pow(2, String.length(str)) |> round() |> Kernel.-(1)) |> Enum.to_list()

    str
    |> String.graphemes()
    |> Enum.reduce(range, &pick_half/2)
    |> Enum.at(0)
  end

  def pick_half(letter, range_arr) do
    [lower, upper] = Enum.chunk_every(range_arr, (length(range_arr) / 2) |> round)
    if letter in ~w(F L), do: lower, else: upper
  end

  def find_missing_seat(seats) do
    all_seats = Enum.to_list(Enum.min(seats)..Enum.max(seats))
    (all_seats -- seats) |> hd
  end
end
