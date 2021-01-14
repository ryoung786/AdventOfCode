defmodule Aoc2019.Intcode.Opcode do
  import Enum

  def halt(state), do: put_in(state.status, :halted)

  def add(param_modes, state) do
    [a, b, {:addr, write_addr}] = params(state, param_modes, 3)
    [a, b] = param_vals([a, b], state.memory)
    mem = Map.put(state.memory, write_addr, a + b)
    Map.merge(state, %{memory: mem, ptr: state.ptr + 4})
  end

  def mult(param_modes, state) do
    [a, b, {:addr, write_addr}] = params(state, param_modes, 3)
    [a, b] = param_vals([a, b], state.memory)
    mem = Map.put(state.memory, write_addr, a * b)
    Map.merge(state, %{memory: mem, ptr: state.ptr + 4})
  end

  def input(_, %{input: []} = state), do: put_in(state.status, :waiting_for_input)

  def input(param_modes, state) do
    [{:addr, write_addr}] = params(state, param_modes, 1)
    [val | input] = state.input
    mem = Map.put(state.memory, write_addr, val)
    Map.merge(state, %{memory: mem, input: input, ptr: state.ptr + 2, status: :running})
  end

  def output(param_modes, state) do
    [val] = params(state, param_modes, 1) |> param_vals(state.memory)
    Map.merge(state, %{output: [val | state.output], ptr: state.ptr + 2})
  end

  def jump_if_true(param_modes, state) do
    [a, b] = params(state, param_modes, 2) |> param_vals(state.memory)

    if a != 0,
      do: Map.put(state, :ptr, b),
      else: Map.update!(state, :ptr, &(&1 + 3))
  end

  def jump_if_false(param_modes, state) do
    [a, b] = params(state, param_modes, 2) |> param_vals(state.memory)

    if a == 0,
      do: Map.put(state, :ptr, b),
      else: Map.update!(state, :ptr, &(&1 + 3))
  end

  def less_than(param_modes, state) do
    [a, b, {:addr, write_addr}] = params(state, param_modes, 3)
    [a, b] = param_vals([a, b], state.memory)

    val = if a < b, do: 1, else: 0
    mem = Map.put(state.memory, write_addr, val)
    Map.merge(state, %{memory: mem, ptr: state.ptr + 4})
  end

  def equals(param_modes, state) do
    [a, b, {:addr, write_addr}] = params(state, param_modes, 3)
    [a, b] = param_vals([a, b], state.memory)

    val = if a == b, do: 1, else: 0
    mem = Map.put(state.memory, write_addr, val)
    Map.merge(state, %{memory: mem, ptr: state.ptr + 4})
  end

  def adjust_relative_base(param_modes, state) do
    [delta] = params(state, param_modes, 1) |> param_vals(state.memory)

    state
    |> Map.update!(:relative_base, &(&1 + delta))
    |> Map.update!(:ptr, &(&1 + 2))
  end

  def params(%{memory: mem, ptr: ptr, relative_base: relative_base}, modes, n) do
    for i <- 1..n do
      param = Map.get(mem, ptr + i, 0)

      case modes |> at(i - 1) do
        :immediate -> {:val, param}
        :relative -> {:addr, param + relative_base}
        _ -> {:addr, param}
      end
    end
  end

  def param_vals(params, memory) do
    Enum.map(params, fn
      {:val, val} -> val
      {:addr, addr} -> Map.get(memory, addr, 0)
    end)
  end
end
