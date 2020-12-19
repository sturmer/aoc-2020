defmodule Day15Test do
  use ExUnit.Case
  doctest Aoc2020.Day15
  import Aoc2020.Day15

  @tag :skip
  test "part 1" do
    assert solve() == 206
  end

  # @tag timeout: :infinity
  @tag :skip
  test "part 2" do
    assert solve(30_000_000) == 955
  end
end
