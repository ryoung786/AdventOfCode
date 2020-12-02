defmodule Aoc.Days.Two do
  alias Aoc.Util

  def process() do
    arr = Util.read_file("02_a.input")
    {count_all_valid_passwords(arr), count_all_valid_passwords_b(arr)}
  end

  def count_all_valid_passwords(arr) do
    arr
    |> Enum.map(fn line ->
      {a, b, letter, password} = parse_line(line)
      is_password_valid(password, {letter, a..b})
    end)
    |> Enum.count(& &1)
  end

  def count_all_valid_passwords_b(arr) do
    arr
    |> Enum.map(fn line ->
      {a, b, letter, password} = parse_line(line)
      is_password_valid_b(password, {letter, a, b})
    end)
    |> Enum.count(& &1)
  end

  @spec parse_line(String.t()) :: {integer(), integer(), String.t(), String.t()}
  def parse_line(line) do
    [_all, a, b, letter, password] =
      Regex.run(~r/(\d+)-(\d+) ([[:lower:]]): ([[:alpha:]]+)/, line)

    [a, b] = [a, b] |> Enum.map(&String.to_integer/1)
    {a, b, letter, password}
  end

  @spec is_password_valid(String.t(), {String.t(), Range.t()}) :: boolean()
  def is_password_valid(password, {letter, range} = _validation_rule) do
    freq = String.graphemes(password) |> Enum.frequencies()
    freq[letter] in range
  end

  @spec is_password_valid_b(String.t(), {String.t(), integer(), integer()}) :: boolean()
  def is_password_valid_b(password, {letter, a, b} = _validation_rule) do
    (String.at(password, a - 1) == letter and String.at(password, b - 1) != letter) or
      (String.at(password, a - 1) != letter and String.at(password, b - 1) == letter)
  end
end
