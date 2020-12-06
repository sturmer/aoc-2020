defmodule Aoc2020.Day06 do
  def solve1 do
    parse_and_solve(&Aoc2020.Day06.count_answers/1)
  end

  def solve2 do
    parse_and_solve(&Aoc2020.Day06.count_agreements/1)
  end

  defp parse_and_solve(fun) do
    case File.read("day6.input.txt") do
      {:ok, content} ->
        String.split(content, "\n\n", trim: true) |> fun.() |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def count_answers(groups) do
    Enum.reduce(groups, 0, fn gr, acc ->
      acc + count_single_group_answers(gr)
    end)
  end

  def count_single_group_answers(g) do
    String.split(g, "\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.concat()
    |> MapSet.new()
    |> MapSet.size()
  end

  def count_agreements(groups) do
    Enum.reduce(groups, 0, fn gr, acc ->
      acc + count_single_group_agreements(gr)
    end)
  end

  def count_single_group_agreements(g) do
    String.split(g, "\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(fn ms, acc -> MapSet.intersection(ms, acc) end)
    |> MapSet.size()
  end
end
