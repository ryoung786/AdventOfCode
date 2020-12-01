defmodule Aoc.Days.OneTest do
  use ExUnit.Case, async: true
  import Aoc.Days.One

  setup_all do
    %{arr: [1721, 979, 366, 299, 675, 1456]}
  end

  test "part a", %{arr: arr} do
    assert(
      MapSet.new([1721, 299]) ==
        pair_that_sums_to_target(arr, 2020) |> Tuple.to_list() |> MapSet.new()
    )
  end

  test "part b", %{arr: arr} do
    assert(
      MapSet.new([979, 366, 675]) ==
        trio_that_sums_to_target(arr, 2020) |> Tuple.to_list() |> MapSet.new()
    )
  end
end
