defmodule Mix.Tasks.GetData do
  use Mix.Task
  @requirements ["app.config"]

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:req)

    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [y: :year, d: :day],
        switches: [year: :integer, day: :integer]
      )

    Aoc.Utils.ensure_input(Keyword.get(opts, :year, 2025), Keyword.get(opts, :day, 1))
  end
end
