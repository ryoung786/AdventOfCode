defmodule Aoc.Days.D_07 do
  use Aoc.Days.Base
  defp parse_input_str(str), do: str |> Util.str_array()

  @impl true
  def part_one(str) do
    m = str |> parse_input_str() |> contained_by_map()
    {"Part one:", f("shiny gold", m) |> Enum.uniq() |> Enum.count()}
  end

  @impl true
  def part_two(str) do
    m = str |> parse_input_str() |> contains_map()
    {"Part two:", g("shiny gold", m)}
  end

  def contains_map(lines), do: lines |> Enum.map(&parse_line/1) |> Enum.into(%{})

  def contained_by_map(lines) do
    lines
    |> Enum.reduce(%{}, fn line, acc ->
      {bag_color, contains_bag_colors} = parse_line(line)

      Enum.reduce(contains_bag_colors, acc, fn {_n, color}, acc2 ->
        Map.update(acc2, color, [bag_color], fn lst -> [bag_color | lst] end)
      end)
    end)
  end

  # example output: {"blue", [{3, "red"}, {1, "black"}]}
  def parse_line(line) do
    [_, bag_color] = Regex.run(~r/^(.*) bags contain/, line)

    {bag_color,
     Regex.scan(~r/([0-9]+) (.*) bags?/U, line)
     |> Enum.map(fn [_, num, bag_color] -> {String.to_integer(num), bag_color} end)}
  end

  def f(color, m) do
    case Map.get(m, color, []) do
      [] -> []
      bags -> Enum.reduce(bags, bags, fn bag, acc -> acc ++ f(bag, m) end)
    end
  end

  def g(color, m) do
    m
    |> Map.get(color, [])
    |> Enum.reduce(0, fn {n, bag}, sum -> sum + n + n * g(bag, m) end)
  end
end
