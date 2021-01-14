defmodule Aoc2020.Days.D_21_Test do
  use ExUnit.Case, async: true
  import Aoc2020.Days.D_21

  setup_all do
    %{
      str: """
      mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
      trh fvjkl sbzzf mxmxvkd (contains dairy)
      sqjhc fvjkl (contains soy)
      sqjhc mxmxvkd sbzzf (contains fish)
      """
    }
  end

  test "part 1", %{str: input} do
    assert {_, 5} = part_one(input)
  end

  test "part 2", %{str: input} do
    assert {_, "mxmxvkd,sqjhc,fvjkl"} = part_two(input)
  end
end
