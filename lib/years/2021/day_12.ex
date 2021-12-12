defmodule Aoc.Year2021.Day12 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> to_graph()
    |> generate_paths()
    |> Enum.count()
  end

  def part_two(input) do
    input
  end

  def to_graph(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [a, b], graph ->
      # graph is bi-directional, so insert an edge for both nodes
      graph
      |> Map.update(a, [b], fn neighbors -> [b | neighbors] end)
      |> Map.update(b, [a], fn neighbors -> [a | neighbors] end)
    end)
  end

  def generate_paths(graph) do
    generate_paths(graph, "start", [])
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.map(fn path ->
      path |> Enum.reverse() |> Enum.join("-")
    end)
  end

  def generate_paths(_graph, "end", visited), do: [["end" | visited]]

  def generate_paths(graph, cur_node, visited) do
    if cave_size(cur_node) == :small && cur_node in visited do
      []
    else
      Enum.reduce(graph[cur_node], [], fn cave, acc ->
        acc ++ generate_paths(graph, cave, [cur_node | visited])
      end)
    end
  end

  defp cave_size(cave), do: if(String.match?(cave, ~r/^[a-z]/), do: :small, else: :large)
end
