defmodule Aoc.Days.D_15_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_15

  test "part 1" do
    assert calc([0, 3, 6], 2020) == 436
    assert calc([1, 3, 2], 2020) == 1
    assert calc([2, 1, 3], 2020) == 10
    assert calc([1, 2, 3], 2020) == 27
    assert calc([2, 3, 1], 2020) == 78
    assert calc([3, 2, 1], 2020) == 438
    assert calc([3, 1, 2], 2020) == 1836
  end

  test "part 2" do
    # assert calc([0, 3, 6], 30_000_000) == 175_594
    # assert calc([1, 3, 2], 30_000_000) == 2578
    # assert calc([2, 1, 3], 30_000_000) == 3_544_142
    # assert calc([1, 2, 3], 30_000_000) == 261_214
    # assert calc([2, 3, 1], 30_000_000) == 6_895_259
    # assert calc([3, 2, 1], 30_000_000) == 18
    # assert calc([3, 1, 2], 30_000_000) == 362
  end
end
