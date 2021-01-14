defmodule Aoc2019.Intcode do
  use GenServer
  import Enum
  import Aoc2019.Intcode.Opcode
  alias Aoc2019.Intcode.Opcode

  defmodule State do
    defstruct(
      memory: %{},
      ptr: 0,
      input: [],
      output: [],
      status: :on,
      relative_base: 0
    )
  end

  ## Client

  def new(program, input \\ []) do
    memory = program |> with_index() |> map(fn {v, i} -> {i, v} end) |> Map.new()
    GenServer.start_link(__MODULE__, %State{memory: memory, input: input})
  end

  def run(vm), do: GenServer.cast(vm, :run)
  def run_sync(vm), do: GenServer.call(vm, :run)
  def step(vm), do: GenServer.call(vm, :step)
  def input(vm, n), do: GenServer.cast(vm, {:input, n})
  def flush_output(vm), do: GenServer.call(vm, :flush_output)
  def get_state(vm), do: GenServer.call(vm, :get_state)

  ## Server

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:flush_output, _from, state) do
    {:reply, state.output, %{state | output: []}}
  end

  @impl true
  def handle_call(:run, _from, state) do
    state = _run(state)

    if state.status == :halted,
      do: {:stop, :normal, state, state},
      else: {:reply, state, state}
  end

  @impl true
  def handle_call(:step, _from, state) do
    state = _step(state)

    if state.status == :halted,
      do: {:stop, :normal, state, state},
      else: {:reply, state, state}
  end

  @impl true
  def handle_cast(:run, state) do
    state = _run(state)

    if state.status == :halted,
      do: {:stop, :normal, state},
      else: {:noreply, state}
  end

  @impl true
  def handle_cast({:input, n}, state) do
    lst = if is_list(n), do: n, else: [n]
    {:noreply, Map.update!(state, :input, &(&1 ++ lst))}
  end

  defp _run(%{status: :halted} = state), do: state
  defp _run(%{status: :waiting_for_input, input: []} = state), do: state
  defp _run({:unrecognized_opcode, opcode}), do: {:unrecognized_opcode, opcode}
  defp _run(state), do: _step(state) |> _run()

  defp _step(%{memory: memory, ptr: ptr} = state) do
    instruction = Map.get(memory, ptr) |> parse_instruction()

    case instruction.opcode do
      99 -> halt(state)
      1 -> add(instruction.param_modes, state)
      2 -> mult(instruction.param_modes, state)
      3 -> Opcode.input(instruction.param_modes, state)
      4 -> Opcode.output(instruction.param_modes, state)
      5 -> jump_if_true(instruction.param_modes, state)
      6 -> jump_if_false(instruction.param_modes, state)
      7 -> less_than(instruction.param_modes, state)
      8 -> equals(instruction.param_modes, state)
      9 -> adjust_relative_base(instruction.param_modes, state)
      opcode -> {:unrecognized_opcode, opcode}
    end
  end

  defp opcode(val), do: rem(val, 100)

  defp param_modes(val) do
    lookup = %{0 => :position, 1 => :immediate, 2 => :relative}
    (val / 100) |> floor() |> Integer.digits() |> reverse() |> map(fn n -> lookup[n] end)
  end

  defp parse_instruction(instruction),
    do: %{opcode: opcode(instruction), param_modes: param_modes(instruction)}
end
