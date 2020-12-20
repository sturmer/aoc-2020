defmodule Aoc2020.Day19.Part2 do
  def solve do
    parse_and_solve(&part_two_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day19.input.txt")
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
  end
end
