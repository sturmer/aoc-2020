defmodule Day15Part1Test do
  use ExUnit.Case
  doctest Aoc2020.Day15.Part1
  import Aoc2020.Day15.Part1

  test "part 1" do
    assert solve() == 206
  end
end
