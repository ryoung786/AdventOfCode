defmodule Aoc2021.Days do
  require Logger

  @completed ~w(1)

  def get_module(day) do
    if day in @completed,
      do: String.to_existing_atom("Elixir.Aoc2021.Days.D_#{String.pad_leading(day, 2, "0")}"),
      else: Aoc2021.Days.Base
  end

  def process(day) do
    module = get_module(day)
    module.process()
  end
end
