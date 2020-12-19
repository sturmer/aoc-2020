defmodule Day12Part2Test do
  use ExUnit.Case
  doctest Aoc2020.Day12.Part2
  import Aoc2020.Day12.Part2

  @tag :skip
  test "example 1" do
    i =
      """
      F10
      N3
      F7
      R90
      F11
      """
      |> String.split("\n", trim: true)
      |> Enum.map(fn <<instr, value::binary>> ->
        {<<instr>>, String.to_integer(value)}
      end)
      |> find_distance(%{east: 10, north: 1}, 0, 0)

    assert i == 286
  end

  @tag :skip
  test "part 2" do
    assert solve() == 52203
  end
end
