defmodule Aoc.Days.D_23 do
  use Aoc.Days.Base

  def parse_input(str),
    do: str |> String.graphemes() |> Enum.map(&String.to_integer/1)

  @impl true
  def part_one(str) do
    {"Part 1:",
     str
     |> parse_input()
     |> to_map()
     |> do_n_rounds(100)
     |> format_part1()}
  end

  @impl true
  def part_two(str) do
    {"Part 2:",
     str
     |> parse_input()
     |> Kernel.++(10..1_000_000 |> Enum.to_list())
     |> to_map()
     |> do_n_rounds(10_000_000)
     |> format_part2()}
  end

  def to_map([curr | _] = arr) do
    {curr,
     arr
     |> Enum.chunk_every(2, 1, [curr])
     |> Enum.reduce(%{}, fn [a, b], m -> Map.put(m, a, b) end)}
  end

  def format_part1({_curr, cups}) do
    {_, lst} = take({1, cups}, Enum.count(cups) - 1)
    lst |> Enum.join()
  end

  def format_part2({_curr, cups}) do
    {_, [a, b]} = take({1, cups}, 2)
    a * b
  end

  def take({curr, cups}, n) do
    {curr, lst} =
      1..n
      |> Enum.reduce({curr, []}, fn _cup, {cup, acc} ->
        next = cups[cup]
        {next, [next | acc]}
      end)

    {curr, Enum.reverse(lst)}
  end

  def do_n_rounds({curr, cups}, n),
    do: Enum.reduce(1..n, {curr, cups}, fn _j, {curr, cups} -> next_round({curr, cups}) end)

  def next_round({curr, cups}) do
    max = Enum.count(cups)
    {last, [p1, p2, p3] = three} = take({curr, cups}, 3)

    cups =
      cups
      |> Map.put(curr, cups[last])
      |> Map.drop(three)

    dst = dest(curr, max, three)
    x = cups[dst]

    cups =
      cups
      |> Map.put(dst, p1)
      |> Map.put(p1, p2)
      |> Map.put(p2, p3)
      |> Map.put(p3, x)

    {cups[curr], cups}
  end

  def dest(1, max, reject_list), do: dest(max + 1, max, reject_list)

  def dest(val, max, reject_list) do
    if (val - 1) in reject_list, do: dest(val - 1, max, reject_list), else: val - 1
  end
end
