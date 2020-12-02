defmodule Aoc.Days.Two do
  alias Aoc.Util

  def process() do
    arr = Util.read_file("02_a.input")

    {count_all_valid_passwords(arr, &is_password_valid/4),
     count_all_valid_passwords(arr, &is_password_valid_b/4)}
  end

  def count_all_valid_passwords(arr, validator_function) do
    arr
    |> Enum.map(fn line ->
      {a, b, letter, password} = parse_line(line)
      validator_function.(a, b, letter, password)
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

  @spec is_password_valid(integer(), integer(), String.t(), String.t()) :: boolean()
  def is_password_valid(min, max, letter, password) do
    freq = String.graphemes(password) |> Enum.frequencies()
    freq[letter] in min..max
  end

  @spec is_password_valid_b(integer(), integer(), String.t(), String.t()) :: boolean()
  def is_password_valid_b(a, b, letter, password) do
    (String.at(password, a - 1) == letter and String.at(password, b - 1) != letter) or
      (String.at(password, a - 1) != letter and String.at(password, b - 1) == letter)
  end
end
