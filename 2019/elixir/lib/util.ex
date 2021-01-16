defmodule Aoc2019.Util do
  def read_file(f), do: File.read!(Path.join(:code.priv_dir(:aoc2019), f))
  def str_array(str), do: str |> String.split("\n", trim: true)
  def int_array(str), do: str |> str_array() |> Enum.map(&String.to_integer/1)

  def to_intcode_program(str) do
    str |> String.trim() |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
  end
end
