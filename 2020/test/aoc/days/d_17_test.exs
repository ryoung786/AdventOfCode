defmodule Aoc.Days.D_17_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_17

  setup_all do
    %{
      str: """
      .#.
      ..#
      ###
      """
    }
  end

  test "part 1", %{str: input} do
    grid = str_to_grid(input)
    assert grid |> run(0) |> count_occupied() == 5
    assert grid |> run(1) |> count_occupied() == 11
    assert grid |> run(3) |> count_occupied() == 38
    assert grid |> run(6) |> count_occupied() == 112
  end

  test "part 2", %{str: input} do
    grid = str_to_grid2(input)
    assert grid |> run2(0) |> count_occupied() == 5
    assert grid |> run2(1) |> count_occupied() == 29
  end
end
