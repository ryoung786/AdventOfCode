defmodule Aoc.Year2021.Day12Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day12

  setup_all do
    small = """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

    med = """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """

    large = """
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """

    {:ok, input_small: small, input_med: med, input_large: large}
  end

  describe "2021 Day 12" do
    test "part 1 small", %{input_small: input} do
      assert part_one(input) == 10
    end

    test "part 1 medium", %{input_med: input} do
      assert part_one(input) == 19
    end

    test "part 1 large", %{input_large: input} do
      assert part_one(input) == 226
    end

    test "part 2 small", %{input_small: input} do
      assert part_two(input) == 36
    end

    test "part 2 medium", %{input_med: input} do
      assert part_two(input) == 103
    end

    test "part 2 large", %{input_large: input} do
      assert part_two(input) == 3509
    end
  end
end
