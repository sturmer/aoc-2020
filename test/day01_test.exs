defmodule Day01Test do
  use ExUnit.Case
  doctest Aoc2020.Day01
  import Aoc2020.Day01

  @tag :skip
  test "Find 2 numbers that sum to 2020" do
    assert find_two_sum([100, 500, 1520]) == 760_000
  end

  @tag :skip
  test "Find 3 numbers that sum to 2020" do
    assert find_three_sum([100, 100, 1820]) == 18_200_000
  end
end
