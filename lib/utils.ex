defmodule Aoc.Utils do
  def get_module(year, day) when is_binary(day) do
    get_module(year, String.to_integer(day))
  end

  def get_module(year, day) do
    day = String.pad_leading("#{day}", 2, "0")
    String.to_existing_atom("Elixir.Aoc.Year#{year}.Day#{day}")
  end

  def get_year_and_day(module) when is_atom(module) do
    module |> Atom.to_string() |> get_year_and_day()
  end

  def get_year_and_day(module) when is_binary(module) do
    [_, year, day] = Regex.run(~r/Year(\d+).Day(\d+)/, module)
    {String.to_integer(year), String.to_integer(day)}
  end

  defmodule Input do
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
end
