defmodule Intcode.Opcode do
  import Enum

  def halt(state), do: state

  def add(param_modes, state) do
    [a, b] = params(state.memory, state.ptr, param_modes, 2)
    mem = Map.put(state.memory, state.memory[state.ptr + 3], a + b)
    Map.merge(state, %{memory: mem, ptr: state.ptr + 4})
  end

  def mult(param_modes, state) do
    [a, b] = params(state.memory, state.ptr, param_modes, 2)
    mem = Map.put(state.memory, state.memory[state.ptr + 3], a * b)
    Map.merge(state, %{memory: mem, ptr: state.ptr + 4})
  end

  def input(state) do
    [val | input] = state.input
    mem = Map.put(state.memory, state.memory[state.ptr + 1], val)
    Map.merge(state, %{memory: mem, input: input, ptr: state.ptr + 2})
  end

  def output(param_modes, state) do
    [val] = params(state.memory, state.ptr, param_modes, 1)
    Map.merge(state, %{output: [val | state.output], ptr: state.ptr + 2})
  end

  def jump_if_true(param_modes, state) do
    [a, b] = params(state.memory, state.ptr, param_modes, 2)

    if a != 0,
      do: Map.put(state, :ptr, b),
      else: Map.update!(state, :ptr, &(&1 + 3))
  end

  def jump_if_false(param_modes, state) do
    [a, b] = params(state.memory, state.ptr, param_modes, 2)

    if a == 0,
      do: Map.put(state, :ptr, b),
      else: Map.update!(state, :ptr, &(&1 + 3))
  end

  def less_than(param_modes, state) do
    [a, b] = params(state.memory, state.ptr, param_modes, 2)

    val = if a < b, do: 1, else: 0
    mem = Map.put(state.memory, state.memory[state.ptr + 3], val)
    Map.merge(state, %{memory: mem, ptr: state.ptr + 4})
  end

  def equals(param_modes, state) do
    [a, b] = params(state.memory, state.ptr, param_modes, 2)

    val = if a == b, do: 1, else: 0
    mem = Map.put(state.memory, state.memory[state.ptr + 3], val)
    Map.merge(state, %{memory: mem, ptr: state.ptr + 4})
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
