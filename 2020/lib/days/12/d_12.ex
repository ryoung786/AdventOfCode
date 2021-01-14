defmodule Aoc2020.Days.D_12 do
  use Aoc2020.Days.Base

  defp parse_input_str(str), do: str |> Util.str_array() |> Enum.map(&parse_line/1)

  @impl true
  def part_one(str) do
    arr = str |> parse_input_str()

    {x, y, _dir} =
      arr
      |> Enum.reduce({0, 0, 0}, fn {op, val}, state ->
        move({op, val}, state)
      end)

    {"Manhattan distance:", abs(x) + abs(y)}
  end

  @impl true
  def part_two(str) do
    arr = str |> parse_input_str()

    {{x, y}, _wp} =
      arr
      |> Enum.reduce({{0, 0}, {10, 1}}, fn {op, val}, state ->
        move_wp({op, val}, state)
      end)

    {"Waypoint manhattan distance:", abs(x) + abs(y)}
  end

  def parse_line(str) do
    {op, val} = String.split_at(str, 1)
    {op, String.to_integer(val)}
  end

  def move({"F", val}, {x, y, dir}), do: move(val, {x, y, dir})
  def move({"N", val}, {x, y, dir}), do: {x, y + val, dir}
  def move({"S", val}, {x, y, dir}), do: {x, y - val, dir}
  def move({"E", val}, {x, y, dir}), do: {x + val, y, dir}
  def move({"W", val}, {x, y, dir}), do: {x - val, y, dir}

  def move({"L", val}, {x, y, dir}), do: {x, y, change_dir(dir, val)}
  def move({"R", val}, {x, y, dir}), do: {x, y, change_dir(dir, -val)}

  def move(val, {x, y, 0}), do: {x + val, y, 0}
  def move(val, {x, y, 90}), do: {x, y + val, 90}
  def move(val, {x, y, 180}), do: {x - val, y, 180}
  def move(val, {x, y, 270}), do: {x, y - val, 270}

  def change_dir(dir, delta) do
    case dir + delta do
      x when x >= 360 -> x - 360
      x when x < 0 -> x + 360
      x -> x
    end
  end

  def move_wp({"F", val}, {{x, y}, {wp_x, wp_y}}),
    do: {{x + val * wp_x, y + val * wp_y}, {wp_x, wp_y}}

  def move_wp({"N", val}, {{x, y}, {wp_x, wp_y}}), do: {{x, y}, {wp_x, wp_y + val}}
  def move_wp({"S", val}, {{x, y}, {wp_x, wp_y}}), do: {{x, y}, {wp_x, wp_y - val}}
  def move_wp({"E", val}, {{x, y}, {wp_x, wp_y}}), do: {{x, y}, {wp_x + val, wp_y}}
  def move_wp({"W", val}, {{x, y}, {wp_x, wp_y}}), do: {{x, y}, {wp_x - val, wp_y}}

  def move_wp({"L", val}, {{x, y}, {wp_x, wp_y}}), do: {{x, y}, rotate_wp({wp_x, wp_y}, val)}
  def move_wp({"R", val}, {{x, y}, {wp_x, wp_y}}), do: {{x, y}, rotate_wp({wp_x, wp_y}, -val)}

  def rotate_wp({x, y}, dir) when dir >= 360, do: rotate_wp({x, y}, dir - 360)
  def rotate_wp({x, y}, dir) when dir < 0, do: rotate_wp({x, y}, dir + 360)
  def rotate_wp({x, y}, 90), do: {-y, x}
  def rotate_wp({x, y}, 180), do: {-x, -y}
  def rotate_wp({x, y}, 270), do: {y, -x}
end
