defmodule Aoc.Util do
  def read_file(f) do
    {:ok, str} = File.read(Path.join(:code.priv_dir(:aoc), f))
    str |> String.split("\n", trim: true)
  end
end
