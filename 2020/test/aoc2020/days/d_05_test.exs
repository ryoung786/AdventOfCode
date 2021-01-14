defmodule Aoc2020.Days.D_05_Test do
  use ExUnit.Case, async: true
  import Aoc2020.Days.D_05

  test "calculate seat id from sstring" do
    assert calc_seat_id("FBFBBFFRLR") == 357
    assert calc_seat_id("BFFFBBFRRR") == 567
    assert calc_seat_id("FFFBBBFRRR") == 119
    assert calc_seat_id("BBFFBBFRLL") == 820
  end

  test "find missing seat" do
    assert find_missing_seat([3, 4, 5, 7, 8]) == 6
    assert find_missing_seat([9, 8, 7, 5, 4, 3]) == 6
    assert find_missing_seat([100, 102, 99, 103]) == 101
  end
end
