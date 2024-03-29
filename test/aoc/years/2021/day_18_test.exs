defmodule Aoc.Year2021.Day18Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day18

  setup_all do
    input = """
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    """

    {:ok, input: input}
  end

  describe "2021 Day 18" do
    test "part one", %{input: input} do
      assert part_one(input) == 4140
    end

    test "explode" do
      assert explode("[7,[6,[5,[4,[3,2]]]]]" |> to_snailfish_num()) ==
               "[7,[6,[5,[7,0]]]]" |> to_snailfish_num()

      assert explode("[[6,[5,[4,[3,2]]]],1]" |> to_snailfish_num()) ==
               "[[6,[5,[7,0]]],3]" |> to_snailfish_num()

      assert explode("[[[[[9,8],1],2],3],4]" |> to_snailfish_num()) ==
               "[[[[0,9],2],3],4]" |> to_snailfish_num()

      assert explode("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]" |> to_snailfish_num()) ==
               "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]" |> to_snailfish_num()

      assert explode("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]" |> to_snailfish_num()) ==
               "[[3,[2,[8,0]]],[9,[5,[7,0]]]]" |> to_snailfish_num()
    end

    test "add" do
      # a = to_snailfish_num("[[[[4,3],4],4],[7,[[8,4],9]]]")
      # b = to_snailfish_num("[1,1]")
      # assert add(a, b) == "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]" |> to_snailfish_num()

      input = """
      [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
      [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
      [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
      [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
      [7,[5,[[3,8],[1,4]]]]
      [[2,[2,2]],[8,[8,1]]]
      [2,9]
      [1,[[[9,3],9],[[9,0],[0,7]]]]
      [[[5,[7,4]],7],1]
      [[[[4,2],2],6],[8,7]]
      """

      assert part_one(input) == 3488

      # [a, b | rest] = to_snailfish_nums(input)

      # assert add(a, b) ==
      #          "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]" |> to_snailfish_num()
    end

    test "magnitude" do
      assert magnitude("[[[[3,0],[5,3]],[4,4]],[5,5]]") == 791
    end

    test "part two", %{input: input} do
      assert part_two(input) == 3993
    end
  end
end
