defmodule Aoc2020.Day18.Part2 do
  def solve do
    parse_and_solve(&part_two_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day18.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  # @doc """
  #
  # """
  def parse_from_string(s) do
    String.split(s, "\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.with_index()
  end

  def part_two_solver(lines) do
    res =
      lines
      |> Enum.reduce(0, fn line, acc ->
        acc + parse_line(line)
      end)

    IO.puts("res: #{res}")
    res
  end

  @doc """
  Strategy: If we had no parens, we can use evaluate_group directly and be done with it.
  With parens, we need to evaluate the innermost group, and go up until we get back to
  a sequence without parens.
  """
  def parse_line(l) do
    last_group =
      l
      |> String.split(~r/[+*()]/, trim: true, include_captures: true)
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(&1 != ""))
      |> Enum.reduce([], fn token, acc ->
        cond do
          String.match?(token, ~r/[0-9]+/) ->
            [String.to_integer(token) | acc]

          String.match?(token, ~r/\)/) ->
            idx = Enum.find_index(acc, &(&1 == "("))
            {group, rest} = Enum.split(acc, idx + 1)

            # IO.puts("group: #{inspect(group, pretty: true, charlists: :as_list)}")
            # IO.puts("rest: #{inspect(rest, pretty: true, charlists: :as_list)}")

            res = evaluate_group(Enum.reverse(group -- [List.last(group)]))

            # x = [res | rest]

            # IO.puts(
            #   "matched ')', group evaluated: #{inspect(x, pretty: true, charlists: :as_list)}"
            # )

            # x
            [res | rest]

          true ->
            [token | acc]
        end
      end)

    # IO.puts("last_group: #{inspect(last_group, pretty: true, charlists: :as_list)}")

    evaluate_group(Enum.reverse(last_group))
  end

  @doc """
  Evaluate unparenthesized expression. Important: there can't be parentheses!
  """
  def evaluate_group([x, "+", y | rest]) do
    # IO.puts("x: #{x}")
    # IO.puts("rest: #{inspect(rest, pretty: true, charlists: :as_list)}")

    evaluate_group([x + y] ++ rest)
  end

  def evaluate_group([x, "*" | rest]) do
    # IO.puts("x: #{x}")
    # IO.puts("rest: #{inspect(rest, pretty: true, charlists: :as_list)}")

    x * evaluate_group(rest)
  end

  def evaluate_group([u]), do: u

  def do_op(a, b, op) do
    case op do
      "+" ->
        a + b

      "*" ->
        a * b
    end
  end
end
