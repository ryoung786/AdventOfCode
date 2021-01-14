defmodule Aoc2020.Days.D_16 do
  use Aoc2020.Days.Base

  def parse_input_str(str) do
    [rules, my_tkt, tkts] = str |> String.split("\n\n", trim: true)

    {
      parse_rules(rules),
      parse_my_ticket(my_tkt),
      parse_nearby_tickets(tkts)
    }
  end

  def parse_rules(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.flat_map(fn line ->
      Regex.scan(~r/(\d+)-(\d+)/, line, capture: :all_but_first)
      |> Enum.map(fn [a, b] -> String.to_integer(a)..String.to_integer(b) end)
    end)
  end

  def parse_my_ticket(str),
    do: str |> String.split("\n", trim: true) |> Enum.drop(1) |> List.first() |> parse_ticket()

  def parse_nearby_tickets(str),
    do: str |> String.split("\n", trim: true) |> Enum.drop(1) |> Enum.map(&parse_ticket/1)

  def parse_ticket(str), do: str |> String.split(",") |> Enum.map(&String.to_integer/1)

  @impl true
  def part_one(str) do
    {ranges, _my_ticket, nearby_tickets} = str |> parse_input_str()

    res =
      nearby_tickets
      |> Enum.concat()
      |> Enum.reject(fn n -> Enum.any?(ranges, &(n in &1)) end)
      |> Enum.sum()

    {"Part 1:", res}
  end

  @impl true
  def part_two(str) do
    {ranges, my_ticket, nearby_tickets} = str |> parse_input_str()
    valid_tickets = discard_invalid_tickets(nearby_tickets, ranges)
    rules = ranges |> Enum.chunk_every(2)
    positions = transpose([my_ticket | valid_tickets])

    possible_fields =
      positions
      |> Enum.with_index()
      |> Map.new(fn {_, i} -> {i, Enum.to_list(0..(Enum.count(positions) - 1))} end)

    answer =
      apply_rules(possible_fields, rules, positions)
      |> propagate()
      |> multiply_departure_fields(my_ticket)

    {"Part 2:", answer}
  end

  def discard_invalid_tickets(tickets, ranges),
    do: tickets |> Enum.reject(&is_ticket_valid(&1, ranges))

  def is_ticket_valid(nums, ranges), do: nums |> Enum.any?(fn n -> !is_num_valid(n, ranges) end)

  def is_num_valid(n, ranges), do: Enum.any?(ranges, &(n in &1))

  def transpose(tickets), do: tickets |> Enum.zip() |> Enum.map(fn tup -> Tuple.to_list(tup) end)

  def apply_rules(m, rules, positions) do
    Enum.map(m, fn {field_i, remaining} ->
      ranges = rules |> Enum.at(field_i)

      {field_i,
       remaining
       |> Enum.filter(fn i ->
         positions |> Enum.at(i) |> Enum.all?(&is_num_valid(&1, ranges))
       end)}
    end)
    |> Enum.into(%{})
  end

  def propagate(map, known \\ %{})
  def propagate(map, known) when map == %{}, do: known

  def propagate(map, known) do
    {field_i, [position_i]} = map |> Enum.find(fn {_, lst} -> length(lst) == 1 end)

    map =
      Enum.reduce(map, %{}, fn {k, remaining}, m ->
        Map.put(m, k, List.delete(remaining, position_i))
      end)

    propagate(Map.delete(map, field_i), Map.put(known, field_i, position_i))
  end

  def multiply_departure_fields(map, tkt) do
    tkt = tkt |> Enum.with_index() |> Map.new(fn {n, i} -> {i, n} end)
    vals = map |> Map.take(Enum.to_list(0..5)) |> Map.values()
    tkt |> Map.take(vals) |> Map.values() |> Enum.reduce(fn a, b -> a * b end)
  end
end
