defmodule Day14Part1Test do
  use ExUnit.Case
  doctest Aoc2020.Day14.Part1
  import Aoc2020.Day14.Part1

  # @tag :skip
  test "part 1" do
    assert solve() == 8_566_770_985_168
  end
end
