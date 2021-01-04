defmodule Aoc.Days.D_08_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_08
  alias Aoc.VM

  setup_all do
    %{
      opcode: """
      nop +0
      acc +1
      jmp +4
      acc +3
      jmp -3
      acc -99
      acc +1
      jmp -4
      acc +6
      """
    }
  end

  defp str_to_opcode(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&VM.parse_opcode_instruction/1)
  end

  test "part a", %{opcode: opcode} do
    opcode = str_to_opcode(opcode)
    assert part_a(opcode) == 5
  end

  test "part b", %{opcode: opcode} do
    opcode = str_to_opcode(opcode)
    assert part_b(opcode) == 8
  end
end
