defmodule Aoc2020.Day18.Part1 do
  def solve do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day18.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  @doc """
      # iex> Aoc2020.Day18.Part1.solve_line("1 + (2 * 3) + (4 * (5 + 6))")
      # 51

      # iex> Aoc2020.Day18.Part1.solve_line("2 * 3 + (4 * 5)")
      # 26

      # iex> Aoc2020.Day18.Part1.solve_line("1 + 2 * 3 + 4 * 5 + 6")
      # 71

      # iex> Aoc2020.Day18.Part1.solve_line("5 + (8 * 3 + 9 + 3 * 4 * 3)")
      # 437

      iex> Aoc2020.Day18.Part1.solve_line("5 + (2 * 3 + 7 + 1)")
      19
  """
  def solve_line(line) do
    tokens = String.split(line, "", trim: true) |> Enum.filter(&(&1 != " "))
    # TODO(gianluca): Remove when done
    # IO.puts("tokens: #{inspect(tokens, pretty: true)}")
    shrink({[], 0, []}, tokens)
  end

  def part_one_solver(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      acc + solve_line(line)
    end)
  end

  @doc """
   (4 * 5 + 9) -> 29
   (4 + 5 * 9) -> 81
   1 + (2 * 3) -> 1 + 6
   1 + (2 * (6 + 2)) -> 1 + (2 * 8)
   Take innermost parenthesized expression and produce its result
   Scan input, accumulate numbers in stack, count parens open
     when closing parens -> process since last open paren
     when end of input, process what's left
   For 1 + (2 * (6 + 2)):
   {tokens, open_parens, pending_op}
   step 0, "1": {[], 0, []}
   step 1, "+": {[1], 0, ["+"]}
   step 2, "(": {[1], 1, ["+"]}
   step 3, "2": {[2, 1], 1, ["+"]}
   step 4, "*": {[2, 1], 1, ["*", "+"]}
   step 5, "(": {[2, 1], 2, ["*", "+"]}
   step 6, "6": {[6, 2, 1], 2, ["*", "+"]}
   step 7, "+": {[6, 2, 1], 2, ["+", "*", "+"]}
   step 8, "2": {[2, 6, 2, 1], 2, ["+", "*", "+"]}
   step 9, ")":
      - pop last pending op: +
      - pop last 2 pending operands: 6, 2
      - push back in the tokens the result
      - open_parens -= 1
      {[8, 2, 1], 1, ["*", "+"]}
   step 10, ")":
      - pop pending op: *
      - pop 2 pending operands: 2, 8
      - push back in the tokens the result (16)
      - open_parens -= 1
      {[16, 1], 0, ["+"]}
    step 11, out of tokens -> use the last 2 with the last op -> 17
    NOTE If no parens open, just accumulate the result
    if open_parens == 0
      pop last token and execute op; push back the result

      # iex> Aoc2020.Day18.Part1.shrink({[1, 2, 8], 1, ["+", "*"]},
      # ...>  ["1", "+", 2", "*", "8"])
      # 24

      # iex> Aoc2020.Day18.Part1.shrink({[16, 1], 0, ["+"]}, [])
      # 17
  """
  def shrink({nums_and_parens, open_parens, ops} = _state, [token | tokens]) do
    IO.puts("nums_and_parens: #{inspect(nums_and_parens, pretty: true)}")
    IO.puts("open_parens: #{open_parens}")
    IO.puts("ops: #{inspect(ops, pretty: true)}")
    IO.puts("token: #{token}")
    IO.puts("tokens: #{inspect(tokens, pretty: true)}\n\n")

    cond do
      open_parens == 0 && Enum.count(nums_and_parens) >= 2 ->
        {op, other_ops} = List.pop_at(ops, -1)
        {rhs, rest} = List.pop_at(nums_and_parens, -1)
        {lhs, more_rest} = List.pop_at(rest, -1)
        res = execute(op, lhs, rhs)
        shrink({more_rest ++ [res], 0, other_ops}, tokens ++ [token])

      token == ")" ->
        # Pop everything till "(" and execute them
        # TODO(gianluca): execute ops on all symbols until last "(", put back the result
        # {op, other_ops} = List.pop_at(ops, -1)
        # {rhs, other_nums} = List.pop_at(nums_and_parens, -1)
        # {lhs, more_nums} = List.pop_at(other_nums, -1)
        # res = execute(op, lhs, rhs)
        # shrink({more_nums ++ [res], open_parens - 1, other_ops}, tokens)
        {res, remaining_num_and_parens, remaining_ops} =
          consume_backwards_till_open_parens(nums_and_parens, ops)

        shrink({[res | remaining_num_and_parens], open_parens, remaining_ops}, tokens)

      token == "(" ->
        shrink({[token | nums_and_parens], open_parens + 1, ops}, tokens)

      token == "+" || token == "*" ->
        shrink({nums_and_parens, open_parens, [token | ops]}, tokens)

      true ->
        # a number
        shrink({[String.to_integer(token) | nums_and_parens], open_parens, ops}, tokens)
    end
  end

  def shrink({nums_and_parens, open_parens, ops} = _state, []) do
    IO.puts("nums_and_parens: #{inspect(nums_and_parens, pretty: true)}")
    IO.puts("open_parens: #{open_parens}")
    IO.puts("ops: #{inspect(ops, pretty: true)}\n\n")

    endgame(nums_and_parens, ops)
  end

  # "5 + (2 * 3 + 7 + 1)" -> ) 1 7 3 2 ( 5, + + * +
  # iex> Aoc2020.Day18.Part1.solve_line()
  def consume_backwards_till_open_parens([a, b | nums], [op | ops]) do
    # TODO(gianluca): Remove when done
    IO.puts("a: #{a}")
    IO.puts("b: #{b}")
    IO.puts("nums: #{inspect(nums, pretty: true)}")
    IO.puts("op: #{op}")
    IO.puts("ops: #{ops}")

    if b == "(" do
      {[a | nums], [op | ops]}
    else
      consume_backwards_till_open_parens([execute(op, a, b) | nums], ops)
    end
  end

  def endgame(nums_and_parens, [op | ops]) do
    IO.puts("nums_and_parens: #{inspect(nums_and_parens, pretty: true)}")
    IO.puts("op: #{op}")
    IO.puts("ops: #{inspect(ops, pretty: true)}\n\n")
    {lhs, rest} = List.pop_at(nums_and_parens, -1)
    {rhs, more_rest} = List.pop_at(rest, -1)
    endgame(more_rest ++ [execute(op, lhs, rhs)], ops)
  end

  def endgame(nums_and_parens, []), do: Enum.at(nums_and_parens, 0)

  def execute(op, lhs, rhs) do
    case op do
      "+" -> lhs + rhs
      "*" -> lhs * rhs
    end
  end
end
