defmodule Aoc2020.Days.D_10_Test do
  use ExUnit.Case, async: true
  import Aoc2020.Days.D_10

  setup_all do
    %{
      input_short: ~w(16 10 15 5 1 11 7 19 6 12 4) |> Enum.join("\n"),
      input_long:
        ~w(28 33 18 42 31 14 46 20 48 47 24 23 49 45 19 38 39 11 1 32 25 35 8 17 7 9 4 2 34 10 3)
        |> Enum.join("\n")
    }
  end

  test "part a", %{input_short: input_short, input_long: input_long} do
    assert {_, 35} = part_one(input_short)
    assert {_, 220} = part_one(input_long)
  end

  test "part b", %{input_short: input_short, input_long: input_long} do
    assert {_, 8} = part_two(input_short)
    assert {_, 19208} = part_two(input_long)
  end
end
