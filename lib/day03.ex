defmodule Aoc2020.Day03 do
  def solve1 do
    case File.read("../day3.input.txt") do
      {:ok, content} ->
        content

      # do something

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end
end
