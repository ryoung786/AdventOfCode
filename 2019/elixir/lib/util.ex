defmodule Util do
  def read_file(f), do: File.read!(f)
  def str_array(str), do: str |> String.split("\n", trim: true)
  def int_array(str), do: str |> str_array() |> Enum.map(&String.to_integer/1)

  def to_intcode_program(str) do
    str |> String.trim() |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
  end
end
