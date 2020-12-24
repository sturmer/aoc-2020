defmodule Day16Part2Test do
  use ExUnit.Case
  doctest Aoc2020.Day16.Part2
  import Aoc2020.Day16.Part2

  test "part 2" do
    assert solve() == 3_429_967_441_937
  end
end
