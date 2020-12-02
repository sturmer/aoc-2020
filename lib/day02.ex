defmodule Aoc2020.Day02 do
  def solve1 do
    case File.read("../day2.input.txt") do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> parse

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def solve2 do
    case File.read("day2.input.txt") do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> parse_policy2

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def parse(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      [policy, password] = String.split(line, ": ", trim: true)
      [minmax, letter] = String.split(policy, " ", trim: true)
      [minelem, maxelem] = String.split(minmax, "-", trim: true)

      # IO.puts("min: #{minelem}, max: #{maxelem}, letter: #{letter}, password: #{password}")

      counts =
        password
        |> String.graphemes()
        |> Enum.reduce(%{}, fn char, acc ->
          Map.put(acc, char, (acc[char] || 0) + 1)
        end)

      lcount = Map.get(counts, letter)
      # IO.inspect(counts)

      if lcount >= String.to_integer(minelem) && lcount <= String.to_integer(maxelem) do
        acc + 1
      else
        acc
      end
    end)
  end

  def parse_policy2(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      [policy, password] = String.split(line, ": ", trim: true)
      [minmax, letter] = String.split(policy, " ", trim: true)
      [minelem, maxelem] = String.split(minmax, "-", trim: true)

      # IO.puts("min: #{minelem}, max: #{maxelem}, letter: #{letter}, password: '#{password}'")

      minidx = String.to_integer(minelem) - 1
      maxidx = String.to_integer(maxelem) - 1

      first = String.slice(password, minidx..minidx)
      second = String.slice(password, maxidx..maxidx)

      # IO.puts(
      #   "At position #{minelem - 1} we have #{first}, " <>
      #     "while at position #{maxelem - 1} we have #{second}"
      # )

      cond do
        first == letter && second == letter ->
          acc

        first == letter || second == letter ->
          acc + 1

        true ->
          acc
      end
    end)
  end
end
