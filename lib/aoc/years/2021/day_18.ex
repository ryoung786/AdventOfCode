defmodule Aoc.Year2021.Day18 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> Input.to_str_list()
    |> Enum.reduce(&add/2)
    |> IO.inspect(label: "final")
    |> magnitude()
  end

  def part_two(input) do
    input
    |> Input.to_str_list()

    "TBD"
  end

  def add(a, b), do: reduce("[#{a},#{b}]")

  def reduce(str) do
    a = explode(str)

    if a != str do
      reduce(a)
    else
      b = split(str)
      if b != str, do: reduce(b), else: str
    end
  end

  # explode("[[6,[5,[4,[3,2]]]],1]") == "[[6,[5,[7,0]]],3]"
  def explode(str) do
    search =
      0..String.length(str)
      |> Enum.reduce_while(0, fn
        i, 5 ->
          {:halt, {:found, i}}

        i, depth ->
          case String.at(str, i) do
            "[" -> {:cont, depth + 1}
            "]" -> {:cont, depth - 1}
            _ -> {:cont, depth}
          end
      end)

    with {:found, i} <- search do
      String.slice(str, i - 3, 10) |> IO.inspect(label: "[xxx] ")
      String.slice(str, i, 3) |> IO.inspect(label: "[huh] ")

      [a, b] =
        String.slice(str, i, 3)
        |> IO.inspect(label: "a")
        |> String.split(",")
        |> IO.inspect(label: "b")
        |> Enum.map(&String.to_integer(&1, 36))
        |> IO.inspect(label: "c")

      str
      |> replace_with_zero(i)
      |> explode_left(i, a)
      |> explode_right(i, b)
    else
      _ -> str
    end
  end

  def replace_with_zero(str, i),
    do: String.slice(str, 0, i - 1) <> "0" <> String.slice(str, i + 4, 99999)

  def explode_left(str, i, n) do
    search =
      str
      |> String.slice(0, i - 1)
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reverse()
      |> Enum.find(fn {ch, _} -> ch not in ~w([ ] ,) end)

    case search do
      nil ->
        str

      {_val, j} when j >= i ->
        str

      {val, j} ->
        val = (String.to_integer(val, 36) + n) |> Integer.to_string(36)
        String.slice(str, 0, j) <> val <> String.slice(str, j + 1, 99999)
    end
  end

  def explode_right(str, i, n) do
    search =
      str
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.slice(i + 1, 9_999_999_999)
      |> Enum.find(fn {ch, _} -> ch not in ~w([ ] ,) end)

    case search do
      {val, idx} ->
        val = (String.to_integer(val, 36) + n) |> Integer.to_string(36)
        String.slice(str, 0, idx) <> val <> String.slice(str, idx + 1, 99999)

      nil ->
        str
    end
  end

  def split(str) do
    str
    |> String.graphemes()
    |> Enum.find_index(fn ch -> ch =~ ~r/[A-Z]/ end)
    |> case do
      nil ->
        str

      i ->
        num = str |> String.at(i) |> String.to_integer(36)
        left = (num / 2) |> trunc() |> Integer.to_string(36)
        right = (num / 2) |> round() |> Integer.to_string(36)
        # {left, right} = {(num / 2) |> trunc(), (num / 2) |> round()}
        new_pair = "[#{left},#{right}]"
        String.slice(str, 0, i) <> new_pair <> String.slice(str, i + 1, 99999)
    end
  end

  def magnitude(str) do
    new_str =
      Regex.replace(~r/\[([0-9]+),([0-9]+)\]/, str, fn _, a, b ->
        [a, b] = Enum.map([a, b], &String.to_integer/1)
        "#{3 * a + 2 * b}"
      end)

    if new_str == str,
      do: String.to_integer(str),
      else: magnitude(new_str)
  end
end
