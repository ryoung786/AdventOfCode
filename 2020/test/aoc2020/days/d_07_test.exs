defmodule Aoc2020.Days.D_07_Test do
  use ExUnit.Case, async: true
  import Aoc2020.Days.D_07

  setup_all do
    %{
      lines_a: """
      light red bags contain 1 bright white bag, 2 muted yellow bags.
      dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      bright white bags contain 1 shiny gold bag.
      muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      faded blue bags contain no other bags.
      dotted black bags contain no other bags.
      """,
      lines_b: """
      shiny gold bags contain 2 dark red bags.
      dark red bags contain 2 dark orange bags.
      dark orange bags contain 2 dark yellow bags.
      dark yellow bags contain 2 dark green bags.
      dark green bags contain 2 dark blue bags.
      dark blue bags contain 2 dark violet bags.
      dark violet bags contain no other bags.
      """
    }
  end

  test "part a", %{lines_a: lines} do
    lines = lines |> String.split("\n", trim: true)
    m1 = lines |> contained_by_map()
    assert 4 == f("shiny gold", m1) |> Enum.uniq() |> Enum.count()
  end

  test "part b", %{lines_a: lines_a, lines_b: lines_b} do
    lines_a = lines_a |> String.split("\n", trim: true)
    m2 = lines_a |> contains_map()
    assert 32 == g("shiny gold", m2)

    lines_b = lines_b |> String.split("\n", trim: true)
    m2 = lines_b |> contains_map()
    assert 126 == g("shiny gold", m2)
  end
end
