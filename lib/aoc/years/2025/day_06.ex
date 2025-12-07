defmodule Aoc.Year2025.Day06 do
  use Aoc.DayBase
  alias Aoc.Utils.Grid

  def part_one(input) do
    input
    |> Grid.new(&if(&1 in ~w/+ */, do: &1, else: String.to_integer(&1)), ~r/\s+/)
    |> Grid.cols()
    |> Enum.sum_by(fn problem ->
      {nums, [op]} = Enum.split(problem, -1)
      if op == "+", do: Enum.sum(nums), else: Enum.product(nums)
    end)
  end

  def part_two(input) do
    input
    |> Grid.new()
    |> Grid.cols()
    |> Enum.concat([[]])
    |> Enum.reduce({[], {[], ""}}, fn col, {problems, {nums, op} = curr} ->
      if Enum.join(col) |> String.trim() == "" do
        {[curr | problems], {[], ""}}
      else
        {col_nums, [col_op]} = Enum.split(col, -1)
        num = col_nums |> Enum.join() |> String.trim() |> String.to_integer()
        {problems, {[num | nums], String.trim(op <> (col_op || ""))}}
      end
    end)
    |> elem(0)
    |> Enum.sum_by(fn {nums, op} ->
      if op == "+", do: Enum.sum(nums), else: Enum.product(nums)
    end)
  end

  def example() do
    """
    123 328  51 64
     45 64  387 23
      6 98  215 314
    *   +   *   +
    """
    |> String.trim()
  end
end
