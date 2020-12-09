defmodule Aoc2020.Day10 do
  @record_separator "\n"

  def solve1 do
    # parse_and_solve(&Aoc2020.Day10.weakness/2, 25)
  end

  def solve2 do
    # parse_and_solve(&Aoc2020.Day10.sumset_master/2, 69_316_178)
  end

  defp parse_and_solve(fun, arg) do
    case File.read("day10.input.txt") do
      {:ok, content} ->
        String.split(content, @record_separator, trim: true) |> fun.(arg) |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end
end
