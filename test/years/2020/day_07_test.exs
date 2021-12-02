defmodule Aoc.Year2020.Day07Test do
  use ExUnit.Case, async: true
  import Aoc.Year2020.Day07

  setup_all do
    input = """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """

    {:ok, input: input}
  end

  describe "2020 day 6" do
    test "part one", %{input: input} do
      assert part_one(input) == 4
    end

    test "part two", %{input: input} do
      assert part_two(input) == 32
    end
  end
end
