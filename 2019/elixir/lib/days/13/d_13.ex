defmodule Aoc2019.Days.D_13 do
  use Aoc2019.Days.Base
  import Enum

  @impl true
  def part_one(str) do
    str |> Util.to_intcode_program() |> start_game() |> count_blocks()
  end

  @impl true
  def part_two(str) do
    str
    |> Util.to_intcode_program()
    |> hack_quarters()
    |> start_game()
    |> play_until_game_over()
    |> get_score()
  end

  def start_game(prog) do
    {:ok, vm} = Intcode.new(prog)
    {vm, Intcode.run_sync(vm)}
  end

  def count_blocks({_vm, state}) do
    state.output
    |> chunk_every(3)
    |> count(fn [tile, _, _] -> tile == 2 end)
  end

  def hack_quarters(prog), do: List.replace_at(prog, 0, 2)

  def play_until_game_over({vm, state}), do: play_until_game_over(vm, state, 0)
  def play_until_game_over(_vm, %{status: :halted} = state, _joystick_x), do: state

  def play_until_game_over(vm, state, joystick_x) do
    Intcode.input(vm, joystick_input(state, joystick_x))

    Intcode.flush_output(vm)
    state = Intcode.run_sync(vm)

    joystick_x = state.output |> chunk_every(3) |> leftmost_tile_of_type(3) || joystick_x

    play_until_game_over(vm, state, joystick_x)
  end

  def get_score(%{output: output}) do
    output |> chunk_every(3) |> find_value(fn [n, 0, -1] -> n end)
  end

  def joystick_input(%{output: output}, last_joystick_x) do
    output = output |> chunk_every(3)
    ball_x = leftmost_tile_of_type(output, 4)
    joy_x = leftmost_tile_of_type(output, 3) || last_joystick_x

    case {joy_x, ball_x} do
      {x, x} -> 0
      {a, b} when a < b -> 1
      {a, b} when a > b -> -1
    end
  end

  defp leftmost_tile_of_type(tiles, tile_id) do
    tiles
    |> filter(fn [tile, _y, _x] -> tile_id == tile end)
    |> min_by(fn [_tile_id, _y, x] -> x end, fn -> [] end)
    |> List.last()
  end
end
