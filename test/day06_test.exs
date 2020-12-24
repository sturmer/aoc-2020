defmodule Day06Test do
  use ExUnit.Case
  doctest Aoc2020.Day06
  import Aoc2020.Day06

  test "count answers in group" do
    assert count_single_group_answers("a\nb\nccc") == 3
    assert count_single_group_answers("xtpmjeuayzkflcdo\nzdaeyxlpftkmojc") == 16
  end

  test "count answers" do
    assert count_answers(["abc", "a\nb\nc", "ab\nac", "a\na\na\na", "b"]) == 11
  end

  test "count agreements" do
    assert count_single_group_agreements("abc") == 3
    assert count_single_group_agreements("a\nb\nc") == 0
  end
end
