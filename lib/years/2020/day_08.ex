defmodule Aoc.Year2020.Day08 do
  use Aoc.DayBase
  alias Aoc.Year2020.Day08.VM

  defp parse_input_str(str),
    do: str |> Input.to_str_list() |> Enum.map(&VM.parse_opcode_instruction/1)

  @impl true
  def part_one(str) do
    opcode = str |> parse_input_str()
    part_a(opcode)
  end

  @impl true
  def part_two(str) do
    opcode = str |> parse_input_str()
    part_b(opcode)
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

  defmodule VM do
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
    def handle_cast({:input, input}, state),
      do: {:noreply, %{state | input: state.input ++ input}}

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
end
