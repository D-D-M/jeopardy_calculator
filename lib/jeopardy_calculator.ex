defmodule JeopardyCalculator do
  import Number.Currency
  @moduledoc """
  Worst-case scenario for Jeopardy, best-case scenario for contestant.
  """

  @jeopardy_board %{ 200 => 6, 400 => 6, 600 => 6, 800 => 6, 1000 => 6 }
  @double_jeopardy_board %{ 400 => 6, 800 => 6, 1200 => 6, 1600 => 6, 2000 => 6 }

  def calculate do
    answer_all_questions_correctly_in_jeopardy_round()
    |> answer_all_questions_correctly_in_double_jeopardy_round
    |> pull_off_a_true_daily_double()
    |> log("shoving it all in on Final Jeopardy")
  end

  def answer_all_questions_correctly_in_jeopardy_round do
    sum_board(@jeopardy_board)
    |> log("answering all questions correctly in Jeopardy round")
    |> handle_daily_doubles(200, 1)
  end

  def answer_all_questions_correctly_in_double_jeopardy_round(sum) do
    total = sum_board(@double_jeopardy_board) + sum

    total
    |> log("answering all questions correctly in Double Jeopardy round")
    |> handle_daily_doubles(400, 2)
  end

  @doc """
  If the location_of_daily_double is a $200 square, that will mean more winnings than
  if it is a $1000 square. The same logic applies to the Double Jeopardy round, with
  the amounts doubled.
  """
  def handle_daily_doubles(whole_board_sum, location_of_daily_double, num_daily_doubles) do
    Enum.reduce(1..num_daily_doubles, whole_board_sum, fn _, acc ->
      acc
      |> guess_daily_double_last(location_of_daily_double)
      |> log("guessing the Daily Double last, in the $#{location_of_daily_double} location")
      |> pull_off_a_true_daily_double()
      |> log("pulling off a true Daily Double")
    end)
  end

  def pull_off_a_true_daily_double(sum), do: sum * 2

  @doc """
  Of course it's not possible to know ahead of time where the Daily Doubles are, but getting
  lucky and guessing them last is the best-case scenario for the contestant to maximize their
  winnings.
  """
  def guess_daily_double_last(whole_board_sum, location_of_daily_double) do
    whole_board_sum - location_of_daily_double
  end

  defp log(val, message) do
    IO.puts "After #{message}, the total is: #{number_to_currency(val)}"
    val
  end

  defp sum_board(board) do
    Enum.map(board, fn {k, v} -> k * v end) |> Enum.sum
  end
end

JeopardyCalculator.calculate()
