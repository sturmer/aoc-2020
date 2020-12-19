defmodule Day13Part1Test do
  use ExUnit.Case
  doctest Aoc2020.Day13.Part1
  import Aoc2020.Day13.Part1

  @tag :skip
  test "example 1" do
    i =
      """
      939
      7,13,x,x,59,x,31,19
      """
      |> String.split("\n", trim: true)
      |> part_one_solver()

    assert i == 295
  end

  @tag :skip
  test "part 1" do
    assert solve() == 4207
  end
end
