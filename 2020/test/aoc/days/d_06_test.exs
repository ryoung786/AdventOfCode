defmodule Aoc.Days.D_06_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_06

  test "part a" do
    assert sum_any("abc") == 3
    assert sum_any("a\nb\nc\n") == 3
    assert sum_any("ab\nac") == 3
    assert sum_any("a\na\na\na\n") == 1
    assert sum_any("b") == 1
  end

  test "part b" do
    assert sum_all("abc") == 3
    assert sum_all("a\nb\nc\n") == 0
    assert sum_all("ab\nac") == 1
    assert sum_all("a\na\na\na\n") == 1
    assert sum_all("b") == 1
  end
end
