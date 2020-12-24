defmodule Day03Test do
  use ExUnit.Case
  doctest Aoc2020.Day03
  import Aoc2020.Day03

  test "part1" do
    input = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

    assert count_trees(String.split(input, "\n", trim: true)) == 7
  end

  test "part2" do
    input = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

    assert count_trees_all(String.split(input, "\n", trim: true)) == 336
  end
end
