defmodule Aoc.Utils.Input do
  def to_str_list(str), do: str |> String.split("\n", trim: true)
  def to_int_list(str), do: str |> to_str_list() |> Enum.map(&String.to_integer/1)

  def to_intcode_program(str) do
    str |> String.trim() |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def read_file(f) do
    Path.join(:code.priv_dir(:aoc), f)
    |> File.read!()
  end

  def read_file(year, day) do
    day = String.pad_leading("#{day}", 2, "0")

    Path.join("#{year}", "#{day}.input")
    |> read_file()
  end

  def list_to_string(lst) when is_list(lst) do
    lst
    |> Enum.map(&to_string/1)
    |> Enum.join("\n")
  end
end
