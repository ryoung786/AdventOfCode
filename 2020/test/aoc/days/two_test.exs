defmodule Aoc.Days.TwoTest do
  use ExUnit.Case, async: true
  import Aoc.Days.Two

  setup_all do
    %{arr: ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]}
  end

  test "part a", %{arr: arr} do
    assert count_all_valid_passwords(arr) == 2
  end

  test "is_password_valid" do
    assert is_password_valid("abcde", {"a", 1..3})
    assert not is_password_valid("cdefg", {"b", 1..3})
    assert is_password_valid("ccccccccc", {"c", 2..9})
    assert not is_password_valid("zrrkcrrrrrlh", {"r", 11..12})
  end

  test "part b", %{arr: arr} do
    assert count_all_valid_passwords_b(arr) == 1
  end

  test "parse_line" do
    assert parse_line("1-3 a: abcde") == {1, 3, "a", "abcde"}
    assert parse_line("1-3 b: cdefg") == {1, 3, "b", "cdefg"}
    assert parse_line("2-9 c: ccccccccc") == {2, 9, "c", "ccccccccc"}
    assert parse_line("11-12 r: zrrkcrrrrrlh") == {11, 12, "r", "zrrkcrrrrrlh"}
  end

  test "is_password_valid_b" do
    assert is_password_valid_b("abcde", {"a", 1, 3})
    assert not is_password_valid_b("cdefg", {"b", 1, 3})
    assert not is_password_valid_b("ccccccccc", {"c", 2, 9})
    assert not is_password_valid_b("zrrkcrrrrrlh", {"r", 11, 12})

    assert not is_password_valid_b("vhqvlvwvzqwqvrxvjnf", {"v", 7, 9})
  end
end
