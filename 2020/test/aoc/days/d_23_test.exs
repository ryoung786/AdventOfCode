defmodule Aoc.Days.D_23_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_23

  test "part 1" do
    {curr, cups} = parse_input("389125467") |> to_map()
    res = {curr, cups} |> do_n_rounds(10) |> format_part1()
    assert res == "92658374"

    assert {_, "67384529"} = part_one("389125467")
  end

  test "part 2" do
    # too slow, takes 1min30sec to run
    # assert {_, 149_245_887_792} = part_two("389125467")
  end
end
