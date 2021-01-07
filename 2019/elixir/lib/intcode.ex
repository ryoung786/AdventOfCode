defmodule Intcode.Opcode do
  import Enum

  def halt(mem), do: mem

  def add(mem, ptr, param_modes) do
    [a, b] = params(mem, ptr, param_modes, 2)
    Map.put(mem, mem[ptr + 3], a + b)
  end

  def mult(mem, ptr, param_modes) do
    [a, b] = params(mem, ptr, param_modes, 2)
    Map.put(mem, mem[ptr + 3], a * b)
  end

  def params(mem, ptr, modes, n) do
    for i <- 1..n do
      case modes |> at(i - 1) do
        :immediate -> mem[ptr + i]
        _ -> mem[mem[ptr + i]]
      end
    end
  end
end

defmodule Intcode do
  import Enum
  import Intcode.Opcode

  def run(program, ptr \\ 0)

  def run(program, ptr) when is_list(program) do
    m = program |> with_index() |> map(fn {v, i} -> {i, v} end) |> Map.new()
    run(m, ptr)
  end

  def run(%{} = memory, ptr) do
    instruction = Map.get(memory, ptr) |> parse_instruction()

    case instruction.opcode do
      99 -> halt(memory)
      1 -> add(memory, ptr, instruction.param_modes) |> run(ptr + 4)
      2 -> mult(memory, ptr, instruction.param_modes) |> run(ptr + 4)
      _ -> :error
    end
  end

  defp opcode(val), do: rem(val, 100)

  defp param_modes(val) do
    lookup = %{0 => :position, 1 => :immediate}
    (val / 100) |> floor() |> Integer.digits() |> reverse() |> map(fn n -> lookup[n] end)
  end

  def parse_instruction(instruction),
    do: %{opcode: opcode(instruction), param_modes: param_modes(instruction)}
end
