defmodule Aoc.Days.D_16_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_16

  setup_all do
    %{
      part1: """
      class: 1-3 or 5-7
      row: 6-11 or 33-44
      seat: 13-40 or 45-50

      your ticket:
      7,1,14

      nearby tickets:
      7,3,47
      40,4,50
      55,2,20
      38,6,12
      """,
      part2: """
      class: 0-1 or 4-19
      row: 0-5 or 8-19
      seat: 0-13 or 16-19

      your ticket:
      11,12,13

      nearby tickets:
      3,9,18
      15,1,5
      5,14,9
      """
    }
  end

  test "part 1", %{part1: input} do
    assert {_, 71} = part_one(input)
  end

  test "discard_invalid_tickets", %{part1: input} do
    {ranges, _my_ticket, tickets} = input |> parse_input_str()
    assert discard_invalid_tickets(tickets, ranges) |> Enum.count() == 1
  end

  test "part 2", %{part2: input} do
    assert {_, 1716} = part_two(input)
  end
end
