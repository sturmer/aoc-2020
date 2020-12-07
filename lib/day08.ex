defmodule Aoc2020.Day08 do
  def solve1 do
    # parse_and_solve(&Aoc2020.Day08.count_paths/1)
  end

  def solve2 do
    # parse_and_solve(&Aoc2020.Day08.count_bags/1)
  end

  defp parse_and_solve(fun) do
    case File.read("day8.input.txt") do
      {:ok, content} ->
        String.split(content, "\n", trim: true) |> fun.() |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end
end
