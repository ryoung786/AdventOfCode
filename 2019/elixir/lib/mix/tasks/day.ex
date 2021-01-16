defmodule Mix.Tasks.Day do
  use Mix.Task

  def run(args) do
    {opts, [day | _], _} =
      OptionParser.parse(args,
        aliases: [p: :part],
        switches: [part: :integer]
      )

    part = Keyword.get(opts, :part, :both)
    module = get_module(day)

    case part do
      1 -> module.part_one()
      2 -> module.part_two()
      _ -> [module.part_one(), module.part_two()]
    end
    |> IO.inspect(label: "Results")
  end

  def get_module(day),
    do: String.to_existing_atom("Elixir.Aoc2019.Days.D_#{String.pad_leading(day, 2, "0")}")
end
