defmodule Day14Part2Test do
  use ExUnit.Case
  doctest Aoc2020.Day14.Part2
  import Aoc2020.Day14.Part2

  @tag :skip
  test "part 2" do
    assert solve() == 8_566_770_985_168
  end
end
