defmodule Aoc2020.Days.D_08 do
  use Aoc2020.Days.Base
  alias Aoc2020.Days.D_08.VM

  defp parse_input_str(str),
    do: str |> Util.str_array() |> Enum.map(&VM.parse_opcode_instruction/1)

  @impl true
  def part_one(str) do
    opcode = str |> parse_input_str()
    {"After loop:", part_a(opcode)}
  end

  @impl true
  def part_two(str) do
    opcode = str |> parse_input_str()
    {"acc after patch:", part_b(opcode)}
  end

  def part_a(opcode) do
    {:ok, vm} = VM.new(opcode)
    VM.run(vm)
    %{status: :loop, acc: acc} = VM.status(vm)
    acc
  end

  def part_b(opcode) do
    opcode
    |> Enum.with_index()
    |> Enum.find_value(fn {_instruction, i} ->
      swapped_opcode = opcode |> swap_at_pos(i)
      {:ok, vm} = VM.new(swapped_opcode)
      VM.run(vm)

      case VM.status(vm) do
        %{status: :terminated, acc: acc} -> acc
        _ -> false
      end
    end)
  end

  defp swap_at_pos(instructions, i), do: List.update_at(instructions, i, &swap_jmp_nop/1)
  defp swap_jmp_nop({:jmp, int}), do: {:nop, int}
  defp swap_jmp_nop({:nop, int}), do: {:jmp, int}
  defp swap_jmp_nop({op, int}), do: {op, int}
end
