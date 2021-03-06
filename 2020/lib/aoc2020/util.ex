defmodule Aoc2020.Util do
  def read_file(f), do: File.read!(Path.join(:code.priv_dir(:aoc2020), f))
  def str_array(str), do: str |> String.split("\n", trim: true)
  def int_array(str), do: str |> str_array() |> Enum.map(&String.to_integer/1)
end
