defmodule Aoc.Year2020.Day19 do
  use Aoc.DayBase

  @impl true
  def part_one(str) do
    {rule_zero, msgs} = str |> parse_input()
    msgs |> Enum.count(fn msg -> match_rule_zero?(msg, rule_zero) end)
  end

  @impl true
  def part_two(str) do
    {rule_zero, msgs} = str |> parse_input(:part2)
    msgs |> Enum.count(fn msg -> match_rule_zero?(msg, rule_zero) end)
  end

  defp swap8and11(m, :part1), do: m

  defp swap8and11(m, :part2) do
    # recursive named patter, see erlang docs
    # https://erlang.org/doc/man/re.html#recursive-patterns
    Map.put(m, 8, "42+")
    |> Map.put(11, "(?<loop> 42 (?&loop)* 31 )")
  end

  def parse_input(input, part \\ :part1) do
    [rules, msgs] = String.split(input, "\n\n", trim: true)

    rule_zero =
      rules
      |> rules_to_map()
      |> swap8and11(part)
      |> reduce_rules()

    {rule_zero, msgs |> String.split("\n", trim: true)}
  end

  def match_rule_zero?(msg, rule), do: Regex.match?(~r/^#{rule}$/U, msg)

  def rules_to_map(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [k, v] = line |> String.split(":")
      {String.to_integer(k), v}
    end)
    |> Enum.into(%{})
  end

  def reduce_rules(rules) do
    if Regex.match?(~r/\d/, rules[0]) do
      rules
      |> find_rule_with_no_numbers()
      |> strip_spaces()
      |> replace_all(rules)
      |> reduce_rules()
    else
      "^" <> String.replace(rules[0], " ", "") <> "$"
    end
  end

  defp find_rule_with_no_numbers(rules),
    do: rules |> Enum.find(fn {_k, v} -> Regex.match?(~r/^[^\d]+$/, v) end)

  defp strip_spaces({i, letters}), do: {i, letters |> String.replace([" ", "\""], "")}

  defp replace_all({i, letters}, rules) do
    rules
    |> Enum.map(fn {k, v} -> {k, swap_rule(i, letters, v)} end)
    |> Enum.into(%{})
    |> Map.delete(i)
  end

  defp swap_rule(tgt, replacement_letters, rule) do
    rule
    |> String.split()
    |> Enum.map(fn token ->
      case Integer.parse(token) do
        {^tgt, rst} -> "(#{replacement_letters})#{rst}"
        _ -> token
      end
    end)
    |> Enum.join(" ")
  end
end
