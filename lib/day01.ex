defmodule Aoc2020.Day01 do
  def solve(part) do
    case File.read("../day1.input.txt") do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> dispatch(part)

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def dispatch(lines, part) do
    if part == :one do
      find_two_sum(lines)
    else
      find_three_sum(lines)
    end
  end

  def find_three_sum(lines) do
    set = MapSet.new(lines)
    find_three_sum_recur(lines, set)
  end

  defp find_three_sum_recur([head | tail], set) do
    second = find_sum(tail, set, 2020 - head)

    if second != false && MapSet.member?(set, 2020 - (head + second)) do
      head * second * (2020 - head - second)
    else
      find_three_sum_recur(tail, set)
    end
  end

  defp find_three_sum_recur(_, _set) do
    IO.puts("not found")
    -1
  end

  # Find the residual sum, return the second element.
  # If the sum is a + b + c, then total is set already to 2020 - a, and
  # this function returns b if c exists such that a + b + c == 2020, false
  # otherwise.
  defp find_sum([head | tail], set, total) do
    if MapSet.member?(set, total - head) do
      total - head
    else
      find_sum(tail, set, total)
    end
  end

  defp find_sum([], _set, _total) do
    false
  end

  def find_two_sum(lines) do
    set = MapSet.new(lines)
    recur_one(lines, set)
  end

  defp recur_one([head | tail], set) do
    if MapSet.member?(set, 2020 - head) do
      head * (2020 - head)
    else
      recur_one(tail, set)
    end
  end

  defp recur_one(_, _set) do
    IO.puts("Not found")
    -1
  end
end
