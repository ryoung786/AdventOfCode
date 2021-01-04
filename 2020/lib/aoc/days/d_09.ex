defmodule Aoc.Days.D_09 do
  use Aoc.Days.Base

  defp parse_input_str(str), do: str |> Util.int_array()

  @impl true
  def part_one(str) do
    input = str |> parse_input_str()
    {"Part one:", part_a(input, 25)}
  end

  @impl true
  def part_two(str) do
    input = str |> parse_input_str()
    invalid_number = part_a(input, 25)
    {"Part two:", part_b(invalid_number, input)}
  end

  def part_a(input, window_size) do
    {window, [val | _]} = input |> Enum.split(window_size)

    if is_valid(val, window),
      do: part_a(Enum.drop(input, 1), window_size),
      else: val
  end

  def is_valid(x, arr), do: Enum.find_value(arr, false, fn n -> (x - n) in arr end)

  def part_b(invalid_number, arr) do
    {min, max} = find_seq(invalid_number, arr) |> Enum.min_max()
    min + max
  end

  def find_seq(target, [_ | rest] = arr) do
    case f(target, [], arr) do
      nil -> find_seq(target, rest)
      seq -> seq
    end
  end

  def f(0, seq, _rest), do: seq
  def f(target, _seq, _rest) when target < 0, do: nil
  def f(target, seq, [val | rest]), do: f(target - val, seq ++ [val], rest)
end
