defmodule Aoc.Days.D_04 do
  use Aoc.Days.Base

  defp parse_input_str(str), do: str |> String.split("\n\n", trim: true)

  @impl true
  def part_one(str) do
    valid_passports = str |> parse_input_str |> Enum.filter(&is_passport_valid/1)
    {"Valid passports:", Enum.count(valid_passports)}
  end

  @impl true
  def part_two(str) do
    valid_passports = str |> parse_input_str |> Enum.filter(&is_passport_valid/1)
    {"Valid passports:", Enum.count(valid_passports, &all_individual_fields_valid(&1))}
  end

  def is_passport_valid(passport_str) do
    missing = ~w(ecl pid eyr hcl byr iyr cid hgt) -- fields(passport_str)
    missing in [[], ~w(cid)]
  end

  def all_individual_fields_valid(passport_str) do
    passport_str
    |> String.split(~r/\s/, trim: true)
    |> Enum.all?(&is_field_valid(&1))
  end

  def fields(passport_str) do
    Regex.scan(~r/([[:lower:]]+):/, passport_str)
    |> Enum.map(fn [_, f] -> f end)
  end

  def is_field_valid(field_str) when is_binary(field_str),
    do: field_str |> String.split(":") |> is_field_valid()

  def is_field_valid(["ecl", val]), do: val in ~w(amb blu brn gry grn hzl oth)
  def is_field_valid(["pid", val]), do: Regex.match?(~r/^[[:digit:]]{9}$/, val)
  def is_field_valid(["hcl", val]), do: Regex.match?(~r/^#[0-9a-f]{6}$/, val)
  def is_field_valid(["eyr", val]), do: four_digit_range(val, 2020..2030)
  def is_field_valid(["byr", val]), do: four_digit_range(val, 1920..2002)
  def is_field_valid(["iyr", val]), do: four_digit_range(val, 2010..2020)
  def is_field_valid(["hgt", val]), do: valid_height(val)
  def is_field_valid(["cid", _val]), do: true

  defp four_digit_range(str, range) do
    case Integer.parse(str) do
      {year, _} -> year in range
      _ -> false
    end
  end

  defp valid_height(hgt) do
    case Regex.run(~r/^([0-9]+)(in|cm)$/, hgt) do
      [_, height_str, "cm"] -> String.to_integer(height_str) in 150..193
      [_, height_str, "in"] -> String.to_integer(height_str) in 59..76
      _ -> false
    end
  end
end
