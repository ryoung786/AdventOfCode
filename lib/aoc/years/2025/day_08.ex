defmodule Aoc.Year2025.Day08 do
  use Aoc.DayBase

  def part_one(input) do
    boxes = parse(input)
    circuits = Enum.map(boxes, &List.wrap/1)

    boxes
    |> Combination.combine(2)
    |> Enum.sort_by(fn [{x1, y1, z1}, {x2, y2, z2}] ->
      :math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2)
    end)
    |> Enum.take(1000)
    |> Enum.reduce(circuits, fn [a, b], circuits ->
      a_circuit = Enum.find(circuits, &(a in &1))
      b_circuit = Enum.find(circuits, &(b in &1))

      if a_circuit == b_circuit do
        circuits
      else
        circuits = circuits |> List.delete(a_circuit) |> List.delete(b_circuit)
        [a_circuit ++ b_circuit | circuits]
      end
    end)
    |> Enum.map(&Enum.count/1)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.product()
  end

  def part_two(input) do
    boxes = parse(input)
    circuits = Enum.map(boxes, &List.wrap/1)

    boxes
    |> Combination.combine(2)
    |> Enum.sort_by(fn [{x1, y1, z1}, {x2, y2, z2}] ->
      :math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2)
    end)
    |> Enum.reduce_while(circuits, fn [a, b], circuits ->
      a_circuit = Enum.find(circuits, &(a in &1))
      b_circuit = Enum.find(circuits, &(b in &1))

      if a_circuit == b_circuit do
        {:cont, circuits}
      else
        circuits = circuits |> List.delete(a_circuit) |> List.delete(b_circuit)
        circuits = [a_circuit ++ b_circuit | circuits]

        if Enum.count(circuits) == 1,
          do: {:halt, elem(a, 0) * elem(b, 0)},
          else: {:cont, circuits}
      end
    end)
  end

  @doc "[ {x, y, z}, {x2, y2, z2}, ... ]"
  def parse(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(fn str ->
      str |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  def example() do
    """
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    """
    |> String.trim()
  end
end
