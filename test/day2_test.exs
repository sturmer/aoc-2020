defmodule Day2Test do
  use ExUnit.Case
  doctest Aoc2020.Day2

  # "1-3 a: aac" = there can be between 1 and 3 letters a in the password
  test "Parse correctly with the first policy" do
    assert Aoc2020.Day2.parse(["1-3 a: aac"]) == 1
    assert Aoc2020.Day2.parse(["1-3 a: aac", "1-2 a: aaa"]) == 1
  end

  # "1-3 a: aac" = the letter a can be in position 1 or 3 (1-based), but not in both
  test "Parse correctly with the second policy" do
    assert Aoc2020.Day2.parse(["1-3 a: aac", "1-2 a: aaa"]) == 1
  end
end
