defmodule Aoc2020.Days.Base do
  require Logger

  @callback part_one(String.t()) :: {String.t(), any()}
  @callback part_two(String.t()) :: {String.t(), any()}

  defmacro __using__([]) do
    quote do
      alias Aoc2020.Util
      require Logger

      @behaviour Aoc2020.Days.Base

      def part_one(), do: input() |> part_one()
      def part_two(), do: input() |> part_two()
      def part_one(_input), do: {"Part one:", "TBD"}
      def part_two(_input), do: {"Part two:", "TBD"}

      def input(),
        do: Path.expand("input", __DIR__) |> File.read!()

      defp day_from_module(as_int \\ false) do
        module_name = __MODULE__ |> Atom.to_string()
        [_, day] = Regex.run(~r/D_(\d+)/, module_name)
        if as_int, do: String.to_integer(day), else: day
      end

      defoverridable part_one: 1
      defoverridable part_two: 1
    end
  end

  def part_one(), do: part_one(nil)
  def part_two(), do: part_two(nil)
  def part_one(_input), do: {"Part one:", "TBD"}
  def part_two(_input), do: {"Part two:", "TBD"}
end
