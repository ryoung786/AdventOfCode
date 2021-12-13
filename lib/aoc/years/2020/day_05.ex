defmodule Aoc.Year2020.Day05 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> to_seat_ids()
    |> Enum.max()
  end

  def part_two(input) do
    [my_seat_id] = Enum.to_list(40..801) -- to_seat_ids(input)
    my_seat_id
  end

  defp to_seat_ids(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(fn str ->
      str |> to_row_col() |> seat_id()
    end)
  end

  defp to_row_col(str) do
    {row_str, col_str} =
      str
      |> String.replace(~w(B R), "1")
      |> String.replace(~w(F L), "0")
      |> String.split_at(7)

    {row, _} = Integer.parse(row_str, 2)
    {col, _} = Integer.parse(col_str, 2)

    {row, col}
  end

  defp seat_id({row, col}), do: row * 8 + col
end
