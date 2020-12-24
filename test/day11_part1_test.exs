defmodule Day11Part1Test do
  use ExUnit.Case
  doctest Aoc2020.Day11.Part1
  import Aoc2020.Day11.Part1

  # TODO(gianluca): move to doctest
  test "all around free" do
    m = ["LLLL", "L#L."]
    refute all_around_free?(m, 0, 0)
    refute all_around_free?(m, 0, 1)
    refute all_around_free?(m, 0, 2)
    assert all_around_free?(m, 0, 3)
    refute all_around_free?(m, 1, 0)
    assert all_around_free?(m, 1, 1)
    refute all_around_free?(m, 1, 2)
    assert all_around_free?(m, 1, 3)
  end

  test "four occupied" do
    m = ["LL##", "L.#.", "LL#."]
    refute four_occupied?(m, 0, 0)
    refute four_occupied?(m, 0, 1)
    refute four_occupied?(m, 0, 2)
    refute four_occupied?(m, 0, 3)
    refute four_occupied?(m, 1, 0)
    refute four_occupied?(m, 1, 1)
    refute four_occupied?(m, 1, 2)
    assert four_occupied?(m, 1, 3)
  end

  test "make free/occupied" do
    m = ["LL##", "L.#.", "LL#."]
    assert make_occupied(m, 0, 0) == "#L##"
    assert make_free(m, 0, 0) == "LL##"
    assert make_free(m, 0, 3) == "LL#L"
    assert make_free(m, 0, 4) == "LL##"
  end

  test "example 2" do
    input_map =
      """
      .L..LL
      LLLLLL
      """
      |> String.split("\n", trim: true)

    output_map = evolve(input_map, 0, 0, input_map)

    # important: rules must be applied at the same time
    assert output_map ==
             """
             .#..##
             ######
             """
             |> String.split("\n", trim: true)
  end

  # Takes too long
  @tag :skip
  test "part 1" do
    assert solve() == 2453
  end
end
