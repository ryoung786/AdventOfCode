defmodule Mix.Tasks.GenYear do
  use Mix.Task

  @valid_years 2015..3000 |> Enum.map(&Integer.to_string/1)

  def run([year]) when year in @valid_years, do: year |> String.to_integer() |> generate()
  def run(_), do: Mix.shell().info(["expected to be run like ", :green, "$ mix gen_year 2022"])

  def generate(year) when year in 2015..3000 do
    # create the years/<year> dir in lib and test
    year_str = Integer.to_string(year)
    Mix.Generator.create_directory(Path.join(["lib", "aoc", "years", year_str]))
    Mix.Generator.create_directory(Path.join(["test", "aoc", "years", year_str]))

    1..25
    |> Enum.each(&Mix.Tasks.GenDay.generate(year, &1))
  end
end
