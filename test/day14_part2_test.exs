defmodule Day14Part2Test do
  use ExUnit.Case
  doctest Aoc2020.Day14.Part2
  import Aoc2020.Day14.Part2

  test "part 2" do
    assert solve() == 4_832_039_794_082
  end
end
