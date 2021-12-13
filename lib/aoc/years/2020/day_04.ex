defmodule Aoc.Year2020.Day04 do
  use Aoc.DayBase

  defp parse_input_str(str), do: str |> String.split("\n\n", trim: true)

  def part_one(input) do
    input |> parse_input_str |> Enum.count(&has_required_fields/1)
  end

  def part_two(input) do
    input
    |> parse_input_str
    |> Enum.filter(&has_required_fields/1)
    |> Enum.count(&all_individual_fields_valid/1)
  end

  def has_required_fields(passport_str) do
    missing = ~w(ecl pid eyr hcl byr iyr cid hgt) -- fields(passport_str)
    missing in [[], ~w(cid)]
  end

  def all_individual_fields_valid(passport_str) do
    passport_str
    |> String.split(~r/\s/, trim: true)
    |> Enum.all?(&valid_field?(&1))
  end

  def fields(passport_str) do
    Regex.scan(~r/([[:lower:]]+):/, passport_str)
    |> Enum.map(fn [_, f] -> f end)
  end

  def valid_field?(field_str) when is_binary(field_str),
    do: field_str |> String.split(":") |> valid_field?()

  def valid_field?(["ecl", val]), do: val in ~w(amb blu brn gry grn hzl oth)
  def valid_field?(["pid", val]), do: Regex.match?(~r/^[[:digit:]]{9}$/, val)
  def valid_field?(["hcl", val]), do: Regex.match?(~r/^#[0-9a-f]{6}$/, val)
  def valid_field?(["eyr", val]), do: four_digit_range(val, 2020..2030)
  def valid_field?(["byr", val]), do: four_digit_range(val, 1920..2002)
  def valid_field?(["iyr", val]), do: four_digit_range(val, 2010..2020)
  def valid_field?(["hgt", val]), do: valid_height(val)
  def valid_field?(["cid", _val]), do: true

  defp four_digit_range(str, range), do: String.to_integer(str) in range

  defp valid_height(hgt) do
    case Regex.run(~r/^([0-9]+)(in|cm)$/, hgt) do
      [_, height_str, "cm"] -> String.to_integer(height_str) in 150..193
      [_, height_str, "in"] -> String.to_integer(height_str) in 59..76
      _ -> false
    end
  end
end
