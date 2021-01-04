defmodule Aoc.Days.D_25_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_25

  setup_all do
    %{
      str: """
      """
    }
  end

  test "transform" do
    assert transform(7, 11) == 17_807_724
    assert transform(7, 8) == 5_764_801
    assert transform(17_807_724, 8) == 14_897_079
    assert transform(5_764_801, 11) == 14_897_079
  end

  test "find loop size" do
    assert find_loop_size(7, 17_807_724) == 11
    assert find_loop_size(7, 5_764_801) == 8
    assert find_loop_size(17_807_724, 14_897_079) == 8
    assert find_loop_size(5_764_801, 14_897_079) == 11
  end

  test "part 1" do
    assert {_, 14_897_079} = part_one("5764801\n17807724")
  end
end
