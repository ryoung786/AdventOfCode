defmodule Mix.Tasks.Day do
  use Mix.Task

  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [d: :day, p: :part],
        switches: [day: :integer, part: :integer]
      )

    day = Keyword.get(opts, :day, 1)
    part = Keyword.get(opts, :part, :both)

    module = day |> Integer.to_string() |> Aoc2020.Days.get_module()

    case part do
      1 -> module.part_one()
      2 -> module.part_two()
      _ -> [module.part_one(), module.part_two()]
    end
    |> IO.inspect(label: "Results")
  end
end
