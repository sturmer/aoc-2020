defmodule Day1Test do
  use ExUnit.Case
  doctest Aoc2020.Day1

  test "Find 2 numbers that sum to 2020" do
    assert Aoc2020.Day1.find_two_sum([100, 500, 1520]) == 760_000
  end

  test "Find 3 numbers that sum to 2020" do
    assert Aoc2020.Day1.find_three_sum([100, 100, 1820]) == 18_200_000
  end
end
