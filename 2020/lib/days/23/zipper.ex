defmodule Aoc2020.Days.D_23.Zipper do
  def new(lst), do: {[], lst}

  def len({a, b}), do: Enum.count(a) + Enum.count(b)
  def to_list({a, b}), do: b ++ Enum.reverse(a)
  def pop({a, []}), do: pop({[], Enum.reverse(a)})
  def pop({a, [x | b]}), do: {x, {a, b}}

  def slice(cups, n) do
    {lst, cups} =
      1..n
      |> Enum.reduce({[], cups}, fn _, {acc, cups} ->
        {x, rest} = pop(cups)
        {[x | acc], rest}
      end)

    {lst |> Enum.reverse(), cups}
  end

  def take(cups, n), do: slice(cups, n) |> elem(0)

  def next(cups, n \\ 1)
  def next(cups, 0), do: cups
  def next({a, [x | b]}, n), do: next({[x | a], b}, n - 1)
  def next({a, []}, n), do: next({[], Enum.reverse(a)}, n)

  def prev(cups, n \\ 1)
  def prev(cups, 0), do: cups
  def prev({[], b}, n), do: prev({Enum.reverse(b), []}, n)
  def prev({[x | a], b}, n), do: prev({a, [x | b]}, n - 1)

  def peek({_, [x | _]}), do: x
  def peek({a, []}), do: peek({[], Enum.reverse(a)})

  def to(cups, target) do
    if len(cups) < 500,
      do: do_to(cups, target),
      else: cups |> prev(1000) |> do_to(target)
  end

  defp do_to(cups, target),
    do: if(peek(cups) == target, do: cups, else: do_to(next(cups), target))

  def insert(cups, []), do: cups
  def insert({a, b}, lst) when is_list(lst), do: {a, lst ++ b}
  def insert({a, b}, x), do: {a, [x | b]}
end
