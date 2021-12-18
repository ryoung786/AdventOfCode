defmodule Aoc.Year2021.Day18 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> to_snailfish_nums()
    |> Enum.reduce(fn num, acc -> add(acc, num) end)
    |> magnitude()
  end

  def part_two(input) do
    all_nums = to_snailfish_nums(input)

    all_nums
    |> Enum.map(&max_magnitude(&1, all_nums))
    |> Enum.max()
  end

  def max_magnitude(num, all_nums) do
    all_nums
    |> Enum.reject(fn n -> n == num end)
    |> Enum.map(fn n -> add(num, n) |> magnitude() end)
    |> Enum.max()
  end

  def to_snailfish_nums(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(&to_snailfish_num/1)
  end

  def to_snailfish_num(str) do
    String.graphemes(str)
    |> Enum.map(fn ch ->
      case Integer.parse(ch) do
        {n, _} -> n
        :error -> ch
      end
    end)
  end

  def add(a, b), do: reduce(["[" | a] ++ [","] ++ b ++ ["]"])

  def reduce(num) do
    a = explode(num)

    if a != num do
      reduce(a)
    else
      b = split(num)
      if b != num, do: reduce(b), else: num
    end
  end

  # explode("[[6,[5,[4,[3,2]]]],1]") == "[[6,[5,[7,0]]],3]"
  def explode(num) do
    search =
      num
      |> Enum.with_index()
      |> Enum.reduce_while(0, fn
        {_, i}, 5 -> {:halt, {:found, i}}
        {"[", _}, depth -> {:cont, depth + 1}
        {"]", _}, depth -> {:cont, depth - 1}
        {_, _}, depth -> {:cont, depth}
      end)

    with {:found, i} <- search do
      [a, ",", b] = Enum.slice(num, i, 3)

      num
      |> replace_with_zero(i)
      |> explode_left(i, a)
      |> explode_right(i, b)
    else
      _ -> num
    end
  end

  def replace_with_zero(num, i) do
    Enum.slice(num, 0, i - 1) ++ [0] ++ Enum.slice(num, i + 4, 9_999_999_999)
  end

  def explode_left(num, i, n) do
    search =
      num
      |> Enum.slice(0, i - 1)
      |> Enum.with_index()
      |> Enum.reverse()
      |> Enum.find(fn {ch, _} -> is_integer(ch) end)

    case search do
      nil -> num
      {_val, j} when j >= i -> num
      {val, j} -> List.replace_at(num, j, val + n)
    end
  end

  def explode_right(num, i, n) do
    search =
      num
      |> Enum.with_index()
      |> Enum.drop(i)
      |> Enum.find(fn {ch, _} -> is_integer(ch) end)

    case search do
      {val, idx} -> List.replace_at(num, idx, val + n)
      nil -> num
    end
  end

  def split(num) do
    num
    |> Enum.find_index(fn ch -> is_integer(ch) and ch >= 10 end)
    |> case do
      nil ->
        num

      i ->
        val = Enum.at(num, i)
        new_pair = ["[", trunc(val / 2), ",", round(val / 2), "]"]
        List.replace_at(num, i, new_pair) |> List.flatten()
    end
  end

  def magnitude(num) when is_list(num), do: magnitude(Enum.join(num))

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
