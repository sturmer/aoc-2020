defmodule Aoc2020.Day10 do
  @record_separator "\n"

  def solve1 do
    parse_and_solve(&Aoc2020.Day10.adapt/1)
  end

  def solve2 do
    parse_and_solve(&Aoc2020.Day10.count_arrangements/1)
  end

  defp parse_and_solve(fun) do
    case File.read("day10.input.txt") do
      {:ok, content} ->
        String.split(content, @record_separator, trim: true)
        |> Enum.map(&String.to_integer/1)
        |> fun.()
        |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def count_arrangements(joltages) do
    joltages_and_wall =
      [0 | joltages]
      |> Enum.sort(&(&1 >= &2))

    # The max is at element 0
    joltages_and_adapter = [Enum.at(joltages_and_wall, 0) + 3 | joltages_and_wall]

    count(joltages_and_adapter, %{})
  end

  # Count backwards from the highest. For a given joltage J,
  # the paths to reach the end are the sum of
  # all the paths from J to the beginning of the rest of the chain.
  # In the first example, the values are:
  # 22 19 16 15 12 11 10 7 6 5 4 1 0
  # From 19 to 22 there's but one path.
  # So is until 11.
  # From 10, we can reach either 11 or 12. So the paths to 22 are 2:
  #   10 -> [11]
  #   10 -> [12]
  # where [x] is the number of paths that go to 22 starting from x.
  # For 4, we have:
  #   4 -> [5] (4 paths)
  #   4 -> [6] (2 paths)
  #   4 -> [7] (2 paths)
  # for a total of 8.
  def count([h | other_joltages], paths) do
    cur =
      Enum.reduce([1, 2, 3], 0, fn x, acc ->
        if Map.has_key?(paths, h + x) do
          acc + Map.get(paths, h + x)
        else
          acc
        end
      end)

    count(other_joltages, Map.put(paths, h, max(cur, 1)))
  end

  def count([], paths) do
    minkey = Map.keys(paths) |> Enum.min()
    Map.get(paths, minkey)
  end

  def adapt(joltages) do
    starting_joltage = 0
    # 1-jolt: cnt, 2-jolts: count
    diffs = %{}

    out = fill_diffs(diffs, Enum.sort(joltages, &(&1 <= &2)), starting_joltage)
    Map.get(out, 1) * Map.get(out, 3)
  end

  def fill_diffs(diffs, [h | joltages], cur) do
    fill_diffs(
      Map.update(diffs, h - cur, 1, &(&1 + 1)),
      joltages,
      h
    )
  end

  def fill_diffs(diffs, [], _cur), do: Map.update(diffs, 3, 1, &(&1 + 1))
end
