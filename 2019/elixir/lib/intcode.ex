defmodule Intcode do
  import Enum

  def run(program, ptr \\ 0)

  def run(program, ptr) when is_list(program) do
    m = program |> with_index() |> map(fn {v, i} -> {i, v} end) |> Map.new()
    run(m, ptr)
  end

  def run(%{} = program, ptr) do
    case Map.get(program, ptr) do
      99 -> halt(program)
      1 -> add(program, ptr) |> run(ptr + 4)
      2 -> mult(program, ptr) |> run(ptr + 4)
      _ -> :error
    end
  end

  def halt(mem), do: mem

  def add(mem, ptr) do
    res = mem[mem[ptr + 1]] + mem[mem[ptr + 2]]
    Map.put(mem, mem[ptr + 3], res)
  end

  def mult(mem, ptr) do
    res = mem[mem[ptr + 1]] * mem[mem[ptr + 2]]
    Map.put(mem, mem[ptr + 3], res)
  end
end
