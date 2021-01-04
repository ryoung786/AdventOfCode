defmodule Aoc.Days.D_02_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_02

  setup_all do
    %{arr: ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]}
  end

  test "part a", %{arr: arr} do
    assert count_all_valid_passwords(arr, &is_password_valid/4) == 2
  end

  test "is_password_valid" do
    assert is_password_valid(1, 3, "a", "abcde")
    assert not is_password_valid(1, 3, "b", "cdefg")
    assert is_password_valid(2, 9, "c", "ccccccccc")
    assert not is_password_valid(11, 12, "r", "zrrkcrrrrrlh")
  end

  test "part b", %{arr: arr} do
    assert count_all_valid_passwords(arr, &is_password_valid_b/4) == 1
  end

  test "parse_line" do
    assert parse_line("1-3 a: abcde") == {1, 3, "a", "abcde"}
    assert parse_line("1-3 b: cdefg") == {1, 3, "b", "cdefg"}
    assert parse_line("2-9 c: ccccccccc") == {2, 9, "c", "ccccccccc"}
    assert parse_line("11-12 r: zrrkcrrrrrlh") == {11, 12, "r", "zrrkcrrrrrlh"}
  end

  test "is_password_valid_b" do
    assert is_password_valid_b(1, 3, "a", "abcde")
    assert not is_password_valid_b(1, 3, "b", "cdefg")
    assert not is_password_valid_b(2, 9, "c", "ccccccccc")
    assert not is_password_valid_b(11, 12, "r", "zrrkcrrrrrlh")

    assert not is_password_valid_b(7, 9, "v", "vhqvlvwvzqwqvrxvjnf")
  end
end
