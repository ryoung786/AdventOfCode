defmodule Aoc2020.Days.D_18_Test do
  use ExUnit.Case, async: true
  import Aoc2020.Days.D_18

  setup_all do
    %{str: ""}
  end

  test "part 1", %{str: _input} do
    assert solve("1 + 2 * 3 + 4 * 5 + 6") == 71
    assert solve("1 + (2 * 3) + (4 * (5 + 6))") == 51
    assert solve("2 * 3 + (4 * 5)") == 26
    assert solve("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437
    assert solve("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240
    assert solve("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632
  end

  test "part 2", %{str: _input} do
    assert solve2("1 + 2 * 3 + 4 * 5 + 6") == 231
    assert solve2("1 + (2 * 3) + (4 * (5 + 6))") == 51
    assert solve2("2 * 3 + (4 * 5)") == 46
    assert solve2("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 1445
    assert solve2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669_060
    assert solve2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340
  end
end
