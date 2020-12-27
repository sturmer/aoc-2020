defmodule Day18Part1Test do
  use ExUnit.Case
  doctest Aoc2020.Day18.Part1
  import Aoc2020.Day18.Part1

  test "part 1" do
    assert solve() == 3_159_145_843_816
  end

  test "solve group" do
    {res, _, _} = evaluate_group([44, "+", 6, "+", 1])
    assert res == 51
  end

  test "parse line" do
    line = "1 + (2 * 3) + (4 * (5 + 6))"
    res = parse_line(line)
    # IO.puts("res: #{inspect(res, pretty: true, charlists: :as_list)}")
    assert res == 51
  end

  test "more ops" do
    line = "8 * 3 + 9 + 3 * 4 * 3"
    assert parse_line(line) == 36 * 4 * 3
  end

  test "parse another line" do
    line = "5 + (8 * 3 + 9 + 3 * 4 * 3)"
    res = parse_line(line)
    # IO.puts("res: #{inspect(res, pretty: true, charlists: :as_list)}")
    assert res == 437
  end

  test "parse complicated line" do
    line = "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
    assert parse_line(line) == 13632
  end
end
