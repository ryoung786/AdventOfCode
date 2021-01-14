defmodule Aoc2019.Days.D_04 do
  use Aoc2019.Days.Base
  import Enum

  @impl true
  def part_one(str) do
    {a, b} = str |> parse_input()

    a..b
    |> filter(&has_two_adj_digits/1)
    |> filter(&digits_never_decrease/1)
    |> count()
  end

  @impl true
  def part_two(str) do
    {a, b} = str |> parse_input()

    a..b
    |> filter(&strict_duplicate/1)
    |> filter(&digits_never_decrease/1)
    |> count()
  end

  defp parse_input(str) do
    [_, a, b] = Regex.run(~r/(\d+)-(\d+)/, str)
    {String.to_integer(a), String.to_integer(b)}
  end

  def has_two_adj_digits(num) do
    num |> Integer.digits() |> chunk_every(2, 1, :discard) |> any?(fn [a, b] -> a == b end)
  end

  def digits_never_decrease(num) do
    num |> Integer.digits() |> chunk_every(2, 1, :discard) |> all?(fn [a, b] -> a <= b end)
  end

  def strict_duplicate(num), do: num |> Integer.digits() |> f()

  defp f([n, n, x, _, _, _]) when n != x, do: true
  defp f([x, n, n, y, _, _]) when n != x and n != y, do: true
  defp f([_, x, n, n, y, _]) when n != x and n != y, do: true
  defp f([_, _, x, n, n, y]) when n != x and n != y, do: true
  defp f([_, _, _, x, n, n]) when n != x, do: true
  defp f(_), do: false
end
