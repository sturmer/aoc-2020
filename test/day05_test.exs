defmodule Day05Test do
  use ExUnit.Case
  doctest Aoc2020.Day05
  import Aoc2020.Day05

  @tag :skip
  test "part1" do
    assert highest_id(["FBFBBFFRLR", "BFFFBBFRRR", "FFFBBBFRRR", "BBFFBBFRLL"]) == 820
  end

  @tag :skip
  test "test get_ids" do
    assert get_id(String.codepoints("FBFBBFFRLR")) == 357
    assert get_id(String.codepoints("BFFFBBFRRR")) == 567
    assert get_id(String.codepoints("FFFBBBFRRR")) == 119
    assert get_id(String.codepoints("BBFFBBFRLL")) == 820
  end

  @tag :skip
  test "finds row" do
    assert find_row(String.codepoints("FBFBBFF"), 0, 127) == 44
    assert find_row(String.codepoints("BFFFBBF"), 0, 127) == 70
    assert find_row(String.codepoints("FFFBBBF"), 0, 127) == 14
    assert find_row(String.codepoints("BBFFBBF"), 0, 127) == 102
  end

  @tag :skip
  test "finds seat" do
    assert find_seat(String.codepoints("RLR"), 0, 7) == 5
    assert find_seat(String.codepoints("RRR"), 0, 7) == 7
    assert find_seat(String.codepoints("RLL"), 0, 7) == 4
  end
end
