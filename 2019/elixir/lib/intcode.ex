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
  use GenServer
  import Enum
  import Intcode.Opcode

  defmodule State, do: defstruct(memory: %{}, ptr: 0, input: [], output: [])

  ## Client

  def new(program) do
    memory = program |> with_index() |> map(fn {v, i} -> {i, v} end) |> Map.new()
    GenServer.start_link(__MODULE__, %State{memory: memory})
  end

  def run(vm), do: GenServer.cast(vm, :run)
  def run_sync(vm), do: GenServer.call(vm, :run)

  ## Server

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call(:run, _from, state) do
    state = _run(state)
    {:stop, :normal, state, state}
  end

  def _run(%{memory: memory, ptr: ptr} = state) do
    instruction = Map.get(memory, ptr) |> parse_instruction()

    case instruction.opcode do
      99 ->
        halt(memory)

      1 ->
        m = add(memory, ptr, instruction.param_modes)
        state |> Map.put(:memory, m) |> Map.update!(:ptr, &(&1 + 4)) |> _run()

      2 ->
        m = mult(memory, ptr, instruction.param_modes)
        state |> Map.put(:memory, m) |> Map.update!(:ptr, &(&1 + 4)) |> _run()

      _ ->
        :error
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
