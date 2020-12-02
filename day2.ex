defmodule Day2 do
  def solve1 do
    case File.read("day2.input.txt") do
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

  defp parse(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      policy_and_password = String.split(line, ":", trim: true)
      minmax_and_letter = String.split(Enum.at(policy_and_password, 0), " ")
      min_max = String.split(Enum.at(minmax_and_letter, 0), "-")
      letter = Enum.at(minmax_and_letter, 1)
      password = Enum.at(policy_and_password, 1)

      # IO.puts(
      #   "min: #{Enum.at(min_max, 0)}, max: #{Enum.at(min_max, 1)}, letter: #{letter}, password: #{
      #     password
      #   }"
      # )

      counts =
        password
        |> String.graphemes()
        |> Enum.reduce(%{}, fn char, acc ->
          Map.put(acc, char, (acc[char] || 0) + 1)
        end)

      lcount = Map.get(counts, letter)
      IO.inspect(counts)

      minelem = Enum.at(min_max, 0) |> String.to_integer()
      maxelem = Enum.at(min_max, 1) |> String.to_integer()

      # IO.puts("lcount #{lcount}, min: #{minelem}, max: #{maxelem}, acc: #{acc}")

      if lcount >= minelem && lcount <= maxelem do
        acc + 1
      else
        acc
      end
    end)
  end

  defp parse_policy2(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      policy_and_password = String.split(line, ": ", trim: true)
      minmax_and_letter = String.split(Enum.at(policy_and_password, 0), " ", trim: true)
      min_max = String.split(Enum.at(minmax_and_letter, 0), "-", trim: true)
      letter = Enum.at(minmax_and_letter, 1)
      password = Enum.at(policy_and_password, 1)
      minelem = Enum.at(min_max, 0) |> String.to_integer()
      maxelem = Enum.at(min_max, 1) |> String.to_integer()

      # IO.puts("min: #{minelem}, max: #{maxelem}, letter: #{letter}, password: '#{password}'")

      minidx = minelem - 1
      maxidx = maxelem - 1

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
