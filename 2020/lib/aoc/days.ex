defmodule Aoc.Days do
  require Logger

  @completed ~w(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25)

  def get_module(day) do
    if day in @completed,
      do: String.to_existing_atom("Elixir.Aoc.Days.D_#{String.pad_leading(day, 2, "0")}"),
      else: Aoc.Days.Base
  end

  def process(day) do
    module = get_module(day)
    module.process()
  end
end
