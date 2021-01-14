defmodule Aoc2019.Days.D_04_Test do
  use ExUnit.Case
  import Aoc2019.Days.D_04

  test "a" do
    n = 111_111
    assert has_two_adj_digits(n) and digits_never_decrease(n)

    n = 223_450
    assert has_two_adj_digits(n) and not digits_never_decrease(n)

    n = 123_789
    assert not has_two_adj_digits(n) and digits_never_decrease(n)
  end

  test "b" do
    assert strict_duplicate(112_233)
    assert not strict_duplicate(123_444)
    assert strict_duplicate(111_122)
  end
end
