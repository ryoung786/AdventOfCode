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

defmodule Intcode do
  use GenServer
  import Enum
  import Intcode.Opcode

  defmodule State, do: defstruct(memory: %{}, ptr: 0, input: [], output: [])

  ## Client

  def new(program, input \\ []) do
    memory = program |> with_index() |> map(fn {v, i} -> {i, v} end) |> Map.new()
    GenServer.start_link(__MODULE__, %State{memory: memory, input: input})
  end

  def run(vm), do: GenServer.cast(vm, :run)
  def run_sync(vm), do: GenServer.call(vm, :run)

  def input(vm, n), do: GenServer.cast(vm, {:input, n})
  def get_state(vm), do: GenServer.call(vm, :get_state)

  ## Server

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:run, _from, state) do
    state = _run(state)
    {:stop, :normal, state, state}
  end

  @impl true
  def handle_cast({:input, n}, state) do
    lst = if is_list(n), do: n, else: [n]
    {:noreply, Map.update!(state, :input, &(&1 ++ lst))}
  end

  def _run(%{memory: memory, ptr: ptr} = state) do
    instruction = Map.get(memory, ptr) |> parse_instruction()

    case instruction.opcode do
      99 -> halt(state)
      1 -> add(instruction.param_modes, state) |> _run()
      2 -> mult(instruction.param_modes, state) |> _run()
      3 -> Intcode.Opcode.input(state) |> _run()
      4 -> Intcode.Opcode.output(instruction.param_modes, state) |> _run()
      5 -> jump_if_true(instruction.param_modes, state) |> _run()
      6 -> jump_if_false(instruction.param_modes, state) |> _run()
      7 -> less_than(instruction.param_modes, state) |> _run()
      8 -> equals(instruction.param_modes, state) |> _run()
      opcode -> {:unrecognized_opcode, opcode}
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
