# 19771 too high
# 48708

defmodule Aoc.Year2021.Day20 do
  use Aoc.DayBase
  alias Aoc.Utils.Matrix

  def part_one(input) do
    {algo, img} = parse_input(input)

    1..2
    |> Enum.reduce(img, fn step, output ->
      enhance(algo, output, step)
    end)
    |> Matrix.count(fn _x, _y, val -> val == "#" end)
  end

  def part_two(input) do
    {algo, img} = parse_input(input)

    1..50
    |> Enum.reduce(img, fn step, output ->
      enhance(algo, output, step)
    end)
    |> Matrix.count(fn _x, _y, val -> val == "#" end)
  end

  def parse_input(input) do
    [algo_str, img_str] = String.split(input, "\n\n", trim: true)
    img = Matrix.from_string(img_str, &Function.identity/1)
    {algo_str, img}
  end

  def enhance(algo, img, step) do
    {algo_0, algo_511} = {String.at(algo, 0), String.at(algo, 511)}

    padding =
      if step == 1 do
        if algo_0 == ".", do: ".", else: algo_511
      else
        algo_0
      end

    padded_img = pad(img, padding)

    padded_img
    |> Matrix.with_xy()
    |> Matrix.map(fn {{x, y}, _val} ->
      enhanced_pixel(algo, padded_img, x, y)
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
    all_padding = for _ <- 1..(w + 4), do: padding

    %Matrix{
      m:
        [all_padding, all_padding] ++
          Enum.map(m, fn row -> [padding, padding] ++ row ++ [padding, padding] end) ++
          [all_padding, all_padding],
      w: w + 4,
      h: h + 4
    }
  end
end
