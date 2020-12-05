defmodule Aoc2020.Day05 do
  def solve1 do
    parse_and_solve(&Aoc2020.Day05.highest_id/1)
  end

  def solve2 do
    parse_and_solve(&Aoc2020.Day05.missing_bps/1)
  end

  defp parse_and_solve(fun) do
    case File.read("day5.input.txt") do
      {:ok, content} ->
        String.split(content, "\n", trim: true) |> fun.() |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def highest_id(boarding_passes) do
    Enum.reduce(boarding_passes, -1, fn bp, acc ->
      max(get_id(String.codepoints(bp)), acc)
    end)
  end

  # Wanted to do some binary search but an easy visual inspection did the trick.
  # This prints all the missing boarding passes in the range 1..897 (there are 897
  # rows in the input file). I ran it once to see how it worked, and it printed
  # very few rows in a pretty predictable pattern:
  # the numbers 1-67, and 524.
  def missing_bps(boarding_passes) do
    ids = Enum.map(boarding_passes, fn bp -> get_id(String.codepoints(bp)) end)

    for x <- 1..897 do
      if !(x in ids) do
        IO.puts(x)
      end
    end
  end

  def get_id(cps) do
    row = find_row(Enum.take(cps, 7), 0, 127)
    seat = find_seat(Enum.take(cps, -3), 0, 7)

    row * 8 + seat
  end

  def find_seat([h | cps], l, r) do
    if h == "L" do
      find_seat(cps, l, r - div(r - l, 2) - 1)
    else
      find_seat(cps, l + div(r - l, 2) + 1, r)
    end
  end

  def find_seat([], l, r), do: div(l + r, 2)

  def find_row([h | cps], l, r) do
    if h == "F" do
      find_row(cps, l, r - div(r - l, 2) - 1)
    else
      find_row(cps, l + div(r - l, 2) + 1, r)
    end
  end

  def find_row([], l, r), do: div(l + r, 2)
end
