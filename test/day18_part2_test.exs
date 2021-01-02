defmodule Day18Part2Test do
  use ExUnit.Case
  doctest Aoc2020.Day18.Part2
  import Aoc2020.Day18.Part2

  test "examples" do
    test_example("1 + 2 * 3 + 4 * 5 + 6", 231)
    test_example("1 + (2 * 3) + (4 * (5 + 6))", 51)
    test_example("2 * 3 + (4 * 5)", 46)
    test_example("5 + (8 * 3 + 9 + 3 * 4 * 3)", 1445)
    test_example("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 669_060)
    test_example("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 23340)
  end

  @tag :skip
  test "evaluate_group" do
    assert evaluate_group([1, "+", 3]) == 4
    assert evaluate_group([1, "*", 3]) == 3
    assert evaluate_group([4, "*", 3, "+", 2]) == 20
    assert evaluate_group([4, "*", 3, "*", 2, "+", 5]) == 84
  end

  defp test_example(line, expected) do
    assert parse_line(line) == expected
  end
end
