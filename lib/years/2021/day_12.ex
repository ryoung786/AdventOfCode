defmodule Aoc.Year2021.Day12 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> to_graph()
    |> generate_paths(false)
    |> Enum.count()
  end

  def part_two(input) do
    input
    |> to_graph()
    |> generate_paths(true)
    |> Enum.count()
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
    # except for start, that is a one-way edge
    |> Map.map(fn {_, neighbors} -> List.delete(neighbors, "start") end)
  end

  defp cave_size(cave), do: if(String.match?(cave, ~r/^[a-z]/), do: :small, else: :large)

  def generate_paths(graph, can_visit_a_small_cave_twice?) do
    generate_paths2(graph, "start", [], !can_visit_a_small_cave_twice?)
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.map(fn path ->
      path |> Enum.reverse() |> Enum.join("-")
    end)
  end

  def generate_paths2(_graph, "end", visited, _exception), do: [["end" | visited]]

  def generate_paths2(graph, cur_node, visited, exception_used?) do
    if cave_size(cur_node) == :small && cur_node in visited do
      if exception_used?,
        do: [],
        else:
          Enum.reduce(graph[cur_node], [], fn cave, acc ->
            acc ++ generate_paths2(graph, cave, [cur_node | visited], true)
          end)
    else
      Enum.reduce(graph[cur_node], [], fn cave, acc ->
        acc ++ generate_paths2(graph, cave, [cur_node | visited], exception_used?)
      end)
    end
  end
end
