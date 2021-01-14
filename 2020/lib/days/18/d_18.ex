defmodule Aoc2020.Days.D_18 do
  use Aoc2020.Days.Base

  @impl true
  def part_one(str) do
    {"Part 1:", str |> Util.str_array() |> Enum.map(&solve/1) |> Enum.sum()}
  end

  @impl true
  def part_two(str) do
    {"Part 2:", str |> Util.str_array() |> Enum.map(&solve2/1) |> Enum.sum()}
  end

  def solve(expr) do
    if String.contains?(expr, "(") do
      Regex.replace(~r/\(([^\(]+)\)/U, expr, fn _, expr -> "#{solve(expr)}" end)
      |> solve()
    else
      # expr without parens, solve left to right one operator at a time
      [a | rest] = String.split(expr, " ", trim: true)

      rest
      |> Enum.chunk_every(2)
      |> Enum.reduce(String.to_integer(a), fn
        ["+", b], res -> res + String.to_integer(b)
        ["*", b], res -> res * String.to_integer(b)
      end)
    end
  end

  def solve2(expr) do
    if String.contains?(expr, "(") do
      Regex.replace(~r/\(([^\(]+)\)/U, expr, fn _, expr -> "#{solve2(expr)}" end)
      |> solve2()
    else
      # expr without parens, solve all + first, then all *
      case {String.contains?(expr, "+"), String.contains?(expr, "*")} do
        {true, _} -> expr |> add() |> solve2()
        {_, true} -> expr |> multiply() |> solve2()
        _ -> String.to_integer(expr)
      end
    end
  end

  @re_add ~r/(\d+) \+ (\d+)/
  @re_mul ~r/(\d+) \* (\d+)/

  def add(expr), do: Regex.replace(@re_add, expr, fn _, a, b -> "#{to_i(a) + to_i(b)}" end)
  def multiply(expr), do: Regex.replace(@re_mul, expr, fn _, a, b -> "#{to_i(a) * to_i(b)}" end)
  defp to_i(str), do: String.to_integer(str)
end
