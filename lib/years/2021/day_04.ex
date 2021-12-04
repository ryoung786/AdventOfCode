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
    [instructions | boards] = input |> String.split("\n\n", trim: true)

    instructions = instructions |> String.split(",") |> Enum.map(&String.to_integer/1)
    boards = Enum.map(boards, &Board.new/1)
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

      boards = boards |> Enum.reject(&Board.is_bingo?/1)

      case boards do
        [] -> {:halt, {losing_board, instruction}}
        _ -> {:cont, boards}
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
      board
      |> Enum.map(fn row ->
        row
        |> Enum.map(fn {val, marked} -> if val == number, do: {val, true}, else: {val, marked} end)
      end)
    end

    def is_bingo?(board) do
      row_bingo = board |> is_row_bingo?()
      column_bingo = board |> transpose() |> is_row_bingo?()

      row_bingo || column_bingo
    end

    defp transpose(m), do: m |> Enum.zip() |> Enum.map(fn tup -> Tuple.to_list(tup) end)

    defp is_row_bingo?(board) do
      Enum.any?(board, fn row ->
        row |> Enum.all?(fn {_, marked} -> marked end)
      end)
    end

    def sum_unmarked(board) do
      board
      |> Enum.map(fn row ->
        row
        |> Enum.filter(fn {_, marked} -> marked == false end)
        |> Enum.map(fn {val, false} -> val end)
        |> Enum.sum()
      end)
      |> Enum.sum()
    end
  end
end
