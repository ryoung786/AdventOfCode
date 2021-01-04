defmodule Aoc.VM do
  use GenServer

  defmodule State,
    do: defstruct(pointer: 0, acc: 0, opcode: [], seen: MapSet.new(), status: :init, input: [])

  @type instruction_t :: {atom(), integer()}

  ## Client ##
  @spec new(list(instruction_t())) :: {:ok, term()}
  def new(opcode \\ []), do: GenServer.start_link(__MODULE__, %State{opcode: opcode})
  def run(vm), do: GenServer.cast(vm, :run)
  def shutdown(vm), do: GenServer.stop(vm)
  def input(vm, input \\ []), do: GenServer.cast(vm, {:input, input})
  def status(vm), do: GenServer.call(vm, :get_status)

  def parse_opcode_instruction(str) do
    [op, int] = str |> String.split()
    {String.to_atom(op), String.to_integer(int)}
  end

  ## Server (callbacks) ##
  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call(:get_status, _from, state), do: {:reply, state, state}

  @impl true
  def handle_cast(:run, state), do: {:noreply, _run(state)}

  @impl true
  def handle_cast({:input, input}, state), do: {:noreply, %{state | input: state.input ++ input}}

  defp _run(%State{pointer: pointer, opcode: opcode, seen: seen} = state) do
    case {pointer in seen, pointer == length(opcode)} do
      {true, _} -> %{state | status: :loop}
      {_, true} -> %{state | status: :terminated}
      _ -> opcode |> Enum.at(pointer) |> process_op(%{state | status: :running})
    end
  end

  defp process_op({:nop, _int}, %State{pointer: pointer, seen: seen} = state),
    do: _run(%{state | pointer: pointer + 1, seen: MapSet.put(seen, pointer)})

  defp process_op({:acc, int}, %State{pointer: pointer, seen: seen, acc: acc} = state),
    do: _run(%{state | pointer: pointer + 1, acc: acc + int, seen: MapSet.put(seen, pointer)})

  defp process_op({:jmp, int}, %State{pointer: pointer, seen: seen} = state),
    do: _run(%{state | pointer: pointer + int, seen: MapSet.put(seen, pointer)})
end
