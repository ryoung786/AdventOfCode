defmodule Aoc.Utils do
  def get_module(year, day) when is_binary(day) do
    get_module(year, String.to_integer(day))
  end

  def get_module(year, day) do
    day = String.pad_leading("#{day}", 2, "0")

    try do
      String.to_existing_atom("Elixir.Aoc.Year#{year}.Day#{day}")
    rescue
      ArgumentError -> Aoc.DayBase
    end
  end

  def get_year_and_day(module) when is_atom(module) do
    module |> Atom.to_string() |> get_year_and_day()
  end

  def get_year_and_day(module) when is_binary(module) do
    [_, year, day] = Regex.run(~r/Year(\d+).Day(\d+)/, module)
    {String.to_integer(year), String.to_integer(day)}
  end
end
