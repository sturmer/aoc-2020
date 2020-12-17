defmodule Day18Part1Test do
  use ExUnit.Case
  doctest Aoc2020.Day18.Part1
  import Aoc2020.Day18.Part1

  @tag :skip
  test "part 1" do
    assert solve() == 21071
  end
end
