defmodule Aoc2020.Day18.Part1 do
  def solve do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day18.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  def part_one_solver(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      acc + parse_line(line)
    end)
  end

  # Parse line.
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

            {res, _, _} = evaluate_group(group)

            # x = [res | rest]
            # IO.puts("x: #{inspect(x, pretty: true, charlists: :as_list)}")
            # x
            [res | rest]

          true ->
            [token | acc]
        end
      end)

    # IO.puts("last_group: #{inspect(last_group, pretty: true, charlists: :as_list)}")

    {res, _, _} = evaluate_group(last_group)
    res
  end

  @doc """
    Solve the symbols inside a parens group.
  """
  def evaluate_group(gr) do
    gr
    |> Enum.reverse()
    |> Enum.reduce({nil, nil, nil}, fn x, acc ->
      {a, b, op} = acc

      cond do
        x == " " || x == "(" || x == ")" ->
          acc

        x == "+" || x == "*" ->
          {a, b, x}

        a == nil ->
          {x, b, op}

        b == nil ->
          {do_op(a, x, op), nil, nil}
      end
    end)
  end

  def do_op(a, b, op) do
    case op do
      "+" ->
        a + b

      "*" ->
        a * b
    end
  end
end
