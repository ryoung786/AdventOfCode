defmodule Aoc.Year2020.Day14 do
  use Aoc.DayBase
  use Bitwise

  def parse_input_str(str), do: Input.to_str_list(str) |> Enum.map(&parse_line/1)

  def parse_line("mask = " <> str), do: {:mask, str}

  def parse_line(str) do
    [_, addr, val] = Regex.run(~r/^mem\[(\d+)\] = (\d+)/, str)
    {:mem, {String.to_integer(addr), String.to_integer(val)}}
  end

  @impl true
  def part_one(str) do
    state = str |> parse_input_str() |> run_all_instructions()
    state[:mem] |> Map.values() |> Enum.sum()
  end

  @impl true
  def part_two(str) do
    state = str |> parse_input_str() |> run_all_instructions(:part2)
    state[:mem] |> Map.values() |> Enum.sum()
  end

  def run_all_instructions(instructions, part \\ :part1) do
    Enum.reduce(instructions, %{mask: "", mem: %{}}, fn instruction, state ->
      process_op(instruction, state, part)
    end)
  end

  def process_op(instruction, state, part \\ :part1)
  def process_op({:mask, val}, state, _is_part2), do: %{state | mask: val}

  def process_op({:mem, {addr, val}}, %{mask: mask} = state, :part1) do
    {new_val, _} = apply_mask(val, mask) |> Integer.parse(2)
    put_in(state[:mem][addr], new_val)
  end

  def process_op({:mem, {addr, val}}, %{mask: mask} = state, :part2) do
    mem_addresses = apply_mask(addr, mask, true) |> all_vals()

    Enum.reduce(mem_addresses, state, fn addr, acc ->
      put_in(acc[:mem][addr], val)
    end)
  end

  def apply_mask(val, mask, x_as_floating \\ false) do
    val
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> Enum.zip(String.graphemes(mask))
    |> Enum.map(&mask_bit(&1, x_as_floating))
    |> Enum.join()
  end

  def mask_bit({_bit, "1"}, _x_as_floating), do: "1"
  def mask_bit({_bit, "0"}, false), do: "0"
  def mask_bit({bit, "0"}, true), do: bit
  def mask_bit({_bit, "X"}, true), do: "X"
  def mask_bit({bit, _}, _x_as_floating), do: bit

  def all_vals(str, acc \\ [0])
  def all_vals("", acc), do: acc
  def all_vals("0" <> rest, acc), do: all_vals(rest, acc)

  def all_vals("1" <> rest, acc),
    do: all_vals(rest, Enum.map(acc, fn n -> (1 <<< String.length(rest)) + n end))

  def all_vals("X" <> rest, acc),
    do: all_vals(rest, Enum.flat_map(acc, fn n -> [n, (1 <<< String.length(rest)) + n] end))
end
