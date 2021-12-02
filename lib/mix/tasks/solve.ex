defmodule Mix.Tasks.Solve do
  use Mix.Task

  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [y: :year, d: :day, p: :part],
        switches: [year: :integer, day: :integer, part: :integer]
      )

    year = Keyword.get(opts, :year, 2021)
    day = Keyword.get(opts, :day, 1)
    part = Keyword.get(opts, :part, :both)

    module = Aoc.Utils.get_module(year, day)

    case part do
      1 ->
        module.part_one() |> IO.inspect(label: "Part one")

      2 ->
        module.part_two() |> IO.inspect(label: "Part two")

      _ ->
        module.part_one() |> IO.inspect(label: "Part one")
        module.part_two() |> IO.inspect(label: "Part two")
    end
  end
end
