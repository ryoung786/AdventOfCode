defmodule Aoc.Year2021.Day04 do
  use Aoc.DayBase
  alias Aoc.Year2021.Day04.Board

  def part_one(input) do
    input
    |> parse_instructions_and_boards()
    |> play_game()
    |> calculate_score()
  end

  def part_two(input) do
    input
    |> parse_instructions_and_boards()
    |> play_game(:return_losing_board)
    |> calculate_score()
  end

  def parse_instructions_and_boards(input) do
    [instructions_str | boards_str] = input |> String.split("\n\n", trim: true)

    instructions = instructions_str |> String.split(",") |> Enum.map(&String.to_integer/1)
    boards = Enum.map(boards_str, &Board.new/1)

    {instructions, boards}
  end

  def play_game({instructions, boards}) do
    instructions
    |> Enum.reduce_while(boards, fn instruction, boards ->
      boards = boards |> Enum.map(&Board.mark(&1, instruction))

      case Enum.find(boards, &Board.is_bingo?/1) do
        nil -> {:cont, boards}
        winning_board -> {:halt, {winning_board, instruction}}
      end
    end)
  end

  def play_game({instructions, boards}, :return_losing_board) do
    instructions
    |> Enum.reduce_while(boards, fn instruction, boards ->
      boards = boards |> Enum.map(&Board.mark(&1, instruction))
      [losing_board | _] = boards

      case Enum.reject(boards, &Board.is_bingo?/1) do
        [] -> {:halt, {losing_board, instruction}}
        remaining_boards -> {:cont, remaining_boards}
      end
    end)
  end

  def calculate_score({winning_board, last_called_number}) do
    Board.sum_unmarked(winning_board) * last_called_number
  end

  defmodule Board do
    def new(input_str) do
      rows = String.split(input_str, "\n", trim: true)

      Enum.map(rows, fn row ->
        row
        |> String.split()
        |> Enum.map(&String.to_integer/1)
        |> Enum.map(fn val -> {val, false} end)
      end)
    end

    def mark(board, number) do
      board |> Enum.map(&mark_cells_in_row(&1, number))
    end

    defp mark_cells_in_row(row, number) do
      Enum.map(row, fn
        {^number, _} -> {number, true}
        {val, marked} -> {val, marked}
      end)
    end

    def is_bingo?(board) do
      is_row_bingo?(board) or is_row_bingo?(transpose(board))
    end

    defp transpose(m), do: m |> Enum.zip() |> Enum.map(fn tup -> Tuple.to_list(tup) end)

    defp is_row_bingo?(board) do
      Enum.any?(board, fn row ->
        row |> Enum.all?(fn {_, marked} -> marked end)
      end)
    end

    def sum_unmarked(board) do
      board
      |> Enum.map(&sum_unmarked_row/1)
      |> Enum.sum()
    end

    defp sum_unmarked_row(row) do
      row
      |> Enum.map(fn
        {val, false} -> val
        {_val, true} -> 0
      end)
      |> Enum.sum()
    end
  end
end
