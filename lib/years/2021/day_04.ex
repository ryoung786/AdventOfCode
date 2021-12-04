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
    defstruct bingos: []

    def new(input_str) do
      rows = String.split(input_str, "\n", trim: true)

      board =
        Enum.map(rows, fn row ->
          row
          |> String.split()
          |> Enum.map(&String.to_integer/1)
        end)

      bingos = Enum.map(board, &MapSet.new/1) ++ Enum.map(transpose(board), &MapSet.new/1)
      %Board{bingos: bingos}
    end

    defp transpose(m), do: m |> Enum.zip() |> Enum.map(fn tup -> Tuple.to_list(tup) end)

    def mark(%Board{} = board, number),
      do: %Board{bingos: Enum.map(board.bingos, &MapSet.delete(&1, number))}

    def is_bingo?(%Board{bingos: bingos}), do: Enum.any?(bingos, &Enum.empty?/1)

    def sum_unmarked(%Board{bingos: bingos}),
      do: bingos |> Enum.map(&Enum.sum/1) |> Enum.sum() |> Kernel.div(2)
  end
end
