defmodule Aoc.Year2021.Day20 do
  use Aoc.DayBase
  alias Aoc.Utils.Matrix

  def part_one(input), do: run(input, 2)
  def part_two(input), do: run(input, 50)

  def run(input, iterations) do
    {algo, img} = parse_input(input)
    padded_img = pad(img, iterations)

    1..iterations
    |> Enum.reduce(padded_img, fn _step, output -> enhance(algo, output) end)
    |> Matrix.count(fn _x, _y, val -> val == "#" end)
  end

  def parse_input(input) do
    [algo_str, img_str] = String.split(input, "\n\n", trim: true)
    img = Matrix.from_string(img_str, &Function.identity/1)
    {algo_str, img}
  end

  def enhance(algo, img) do
    img
    |> Matrix.with_xy()
    |> Matrix.map(fn {{x, y}, _val} ->
      enhanced_pixel(algo, img, x, y)
    end)
  end

  def enhanced_pixel(algo_str, img, x, y) do
    String.at(algo_str, calc_index(img, x, y))
  end

  def calc_index(%Matrix{} = m, x, y) do
    [
      Matrix.at(m, {x - 1, y - 1}),
      Matrix.at(m, {x, y - 1}),
      Matrix.at(m, {x + 1, y - 1}),
      Matrix.at(m, {x - 1, y}),
      Matrix.at(m, {x, y}),
      Matrix.at(m, {x + 1, y}),
      Matrix.at(m, {x - 1, y + 1}),
      Matrix.at(m, {x, y + 1}),
      Matrix.at(m, {x + 1, y + 1})
    ]
    |> Enum.map(fn
      "#" -> 1
      "." -> 0
      nil -> if Matrix.at(m, 0, 0) == "#", do: 1, else: 0
    end)
    |> Integer.undigits(2)
  end

  def pad(%Matrix{m: m, w: w, h: h}, padding) do
    all_padding =
      for _ <- 1..padding do
        for _ <- 1..(w + padding * 2), do: "."
      end

    h_pad = for _ <- 1..padding, do: "."

    %Matrix{
      m:
        all_padding ++
          Enum.map(m, fn row -> h_pad ++ row ++ h_pad end) ++
          all_padding,
      w: w + padding * 2,
      h: h + padding * 2
    }
  end
end
