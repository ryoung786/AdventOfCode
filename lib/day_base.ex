defmodule Aoc.DayBase do
  require Logger

  @callback part_one(String.t()) :: any()
  @callback part_two(String.t()) :: any()

  defmacro __using__([]) do
    quote do
      alias Aoc.Utils
      alias Aoc.Utils.Input
      alias Aoc.Intcode
      require Logger

      @behaviour Aoc.DayBase

      def part_one(), do: input() |> part_one()
      def part_two(), do: input() |> part_two()
      def part_one(_input), do: "TBD"
      def part_two(_input), do: "TBD"

      def input() do
        {year, day} = Utils.get_year_and_day(__MODULE__)
        Input.read_file(year, day)
      end

      defoverridable part_one: 1
      defoverridable part_two: 1
    end
  end

  def part_one(), do: part_one(nil)
  def part_two(), do: part_two(nil)
  def part_one(_input), do: "TBD"
  def part_two(_input), do: "TBD"
end
