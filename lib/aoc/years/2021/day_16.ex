defmodule Aoc.Year2021.Day16 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> Base.decode16!()
    |> parse_instruction()
    |> IO.inspect(label: "[xxx] ")
  end

  def part_two(input) do
    input
    |> Input.to_str_list()

    "TBD"
  end

  def parse_instruction(bits) when bit_size(bits) < 6, do: []
  # Literal
  def parse_instruction(<<version::3, 4::3, rest::bits>>) do
    {val, rest} = parse_literal(rest)
    [{version, 4, bitstring_to_int(val)} | parse_instruction(rest)]
  end

  # Has sub-packets, L=0
  def parse_instruction(
        <<version::size(3), type_id::size(3), 0::1, total_length_in_bits::15, rest::bits>>
      ) do
    <<sub_packets::size(total_length_in_bits), rest::bits>> = rest

    [
      {version, type_id, parse_instruction(<<sub_packets::size(total_length_in_bits)>>)}
      | parse_instruction(rest)
    ]
  end

  # Has sub-packets, L=1
  def parse_instruction(
        <<_version::size(3), _type_id::size(3), 1::1, num_sub_packets::11, rest::bits>>
      ) do
    {num_sub_packets, rest}
  end

  def parse_literal(<<0::1, num::4, rest::bits>>) do
    {<<num::4>>, rest}
  end

  def parse_literal(<<1::1, num::4, rest::bits>>) do
    {right, rest} = parse_literal(rest)

    {<<num::4, right::bits>>, rest}
  end

  def bitstring_to_int(bits) do
    sz = bit_size(bits)
    <<n::size(sz)>> = bits
    n
  end
end
