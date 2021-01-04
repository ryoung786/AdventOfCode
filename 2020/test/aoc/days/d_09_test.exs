defmodule Aoc.Days.D_09_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_09

  setup_all do
    %{
      input: """
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
      """
    }
  end

  defp str_to_int_arr(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  test "part a", %{input: input_str} do
    input_arr = str_to_int_arr(input_str)
    assert part_a(input_arr, 5) == 127
  end

  test "is_valid" do
    assert is_valid(95, [47, 40, 62, 55, 65])
  end

  test "part b", %{input: input_str} do
    input_arr = str_to_int_arr(input_str)
    assert part_b(127, input_arr) == 62
  end
end
