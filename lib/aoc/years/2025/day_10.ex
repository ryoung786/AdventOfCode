defmodule Aoc.Year2025.Day10 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> parse()
    |> Enum.map(&process/1)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Input.to_str_list()

    "TBD"
  end

  def process({lights_str, wiring, _joltage}) do
    target = String.graphemes(lights_str)
    all_off = Enum.map(target, fn _ -> "." end)
    Process.put(:seen, [])

    Enum.reduce_while(0..99_999_999, [{all_off, 0}], fn _, [{state, presses} | queue] ->
      # IO.inspect({Enum.join(state), presses}, label: "[xxx] processing")
      seen = Process.get(:seen, [])

      cond do
        state == target ->
          {:halt, presses}

        state in seen ->
          {:cont, queue}

        true ->
          Process.put(:seen, [state | seen])
          {:cont, queue ++ next(state, wiring, presses + 1)}
      end
    end)
  end

  def next(state, wiring, num_presses) do
    press_all = fn btns ->
      Enum.reduce(btns, state, fn btn, acc ->
        List.update_at(acc, btn, &if(&1 == ".", do: "#", else: "."))
      end)
    end

    Enum.map(wiring, &{press_all.(&1), num_presses})
  end

  def parse(input) do
    input
    |> Input.to_str_list()
    |> Enum.map(fn line ->
      [[_, lights, btns, joltage]] = Regex.scan(~r/\[(.*)\] (.*) \{(.*)\}/, line)

      btns =
        btns |> String.replace("(", "[") |> String.replace(")", "]") |> String.replace(" ", ",")

      {btns, _} = Code.eval_string("[#{btns}]")
      {joltage, _} = Code.eval_string("[#{joltage}]")
      {lights, btns, joltage}
    end)
  end

  def example() do
    """
    [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
    [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
    """
    |> String.trim()
  end
end
