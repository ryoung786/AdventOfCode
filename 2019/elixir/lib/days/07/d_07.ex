defmodule Aoc2019.Days.D_07 do
  use Aoc2019.Days.Base

  @impl true
  def part_one(str) do
    str |> Util.to_intcode_program() |> max_thruster_signal(0..4)
  end

  @impl true
  def part_two(str) do
    str |> Util.to_intcode_program() |> max_thruster_signal(5..9)
  end

  def create_amps(phase_sequence, program) do
    for phase <- phase_sequence do
      {:ok, amp} = Intcode.new(program, [phase])
      amp
    end
  end

  def thruster_signal([amp | _] = amps) do
    Intcode.input(amp, 0)
    thruster_signal(0, amps)
  end

  def thruster_signal(4, amps) do
    amp = Enum.at(amps, 4)
    state = Intcode.run_sync(amp)

    case state.status do
      :halted ->
        state.output |> List.first()

      _ ->
        Intcode.input(Enum.at(amps, 0), hd(state.output))
        if state.input |> Enum.count() > 10, do: -99, else: thruster_signal(0, amps)
    end
  end

  def thruster_signal(i, amps) do
    amp = Enum.at(amps, i)
    %{output: [val | _]} = Intcode.run_sync(amp)
    Intcode.input(Enum.at(amps, i + 1), val)
    thruster_signal(i + 1, amps)
  end

  def max_thruster_signal(program, phases) do
    phases
    |> Combination.permutate()
    |> Enum.map(fn phase_sequence ->
      create_amps(phase_sequence, program) |> thruster_signal()
    end)
    |> Enum.max()
  end
end
