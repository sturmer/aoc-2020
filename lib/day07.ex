defmodule Aoc2020.Day07 do
  def solve1 do
    # parse_and_solve(&Aoc2020.Day07.count_answers/1)
  end

  def solve2 do
    # parse_and_solve(&Aoc2020.Day07.count_agreements/1)
  end

  defp parse_and_solve(fun) do
    case File.read("day7.input.txt") do
      {:ok, content} ->
        String.split(content, "\n\n", trim: true) |> fun.() |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end
end
