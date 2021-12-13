defmodule Mix.Tasks.GenDay do
  use Mix.Task

  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [y: :year, d: :day],
        switches: [year: :integer, day: :integer]
      )

    assigns = %{
      "year" => Keyword.get(opts, :year, 2021),
      "day" => Keyword.get(opts, :day) |> String.pad_leading(2)
    }

    # lib/aoc/years/2021/day_01.ex
    Mix.Generator.copy_template(
      Path.join([:code.priv_dir(:aoc), "templates", "day.ex.eex"]),
      Path.join(["lib", "aoc", "years", assigns["year"], "day_#{assigns["day"]}.ex"]),
      assigns |> Enum.into([])
    )

    # test/aoc/years/2021/day_01_test.exs
    Mix.Generator.copy_template(
      Path.join([:code.priv_dir(:aoc), "templates", "day_test.exs.eex"]),
      Path.join(["test", "aoc", "years", assigns["year"], "day_#{assigns["day"]}_test.exs"]),
      assigns |> Enum.into([])
    )

    # priv/01.input
    Mix.Generator.create_file(Path.join(["priv", assigns["year"], "#{assigns["day"]}.input"]), "")
  end
end
