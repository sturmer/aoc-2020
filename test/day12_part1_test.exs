defmodule Day12Part1Test do
  use ExUnit.Case
  doctest Aoc2020.Day12.Part1
  import Aoc2020.Day12.Part1

  test "example 1" do
    i =
      """
      F10
      N3
      F7
      R90
      F11
      """
      |> String.split("\n", trim: true)
      |> find_distance(:east, 0, 0)

    assert i == 25
  end

  test "part 1" do
    assert solve() == 1148
  end
end
