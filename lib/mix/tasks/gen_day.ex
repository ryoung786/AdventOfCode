defmodule Mix.Tasks.GenDay do
  use Mix.Task
  @requirements ["app.config"]

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:req)

    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [y: :year, d: :day, t: :with_test],
        switches: [year: :integer, day: :integer, with_test: :boolean]
      )

    year = Keyword.get(opts, :year, 2025)
    day = Keyword.get(opts, :day, 1)

    generate(year, day, Keyword.get(opts, :with_test, false))
    Aoc.Utils.ensure_input(year, day)
  end

  def generate(year, day, with_test?) when is_integer(year) and is_integer(day) do
    assigns = %{
      year: year |> Integer.to_string(),
      day: day |> Integer.to_string() |> String.pad_leading(2, "0")
    }

    # lib/aoc/years/2021/day_01.ex
    Mix.Generator.copy_template(
      Path.join([:code.priv_dir(:aoc), "templates", "day.ex.eex"]),
      Path.join(["lib", "aoc", "years", assigns.year, "day_#{assigns.day}.ex"]),
      assigns |> Enum.into([])
    )

    # test/aoc/years/2021/day_01_test.exs
    if with_test? do
      Mix.Generator.copy_template(
        Path.join([:code.priv_dir(:aoc), "templates", "day_test.exs.eex"]),
        Path.join(["test", "aoc", "years", assigns.year, "day_#{assigns.day}_test.exs"]),
        assigns |> Enum.into([])
      )
    end

    # priv/01.input
    Mix.Generator.create_file(Path.join(["priv", assigns.year, "#{assigns.day}.input"]), "")
  end
end
