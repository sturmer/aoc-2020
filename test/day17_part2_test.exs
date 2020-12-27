defmodule Day17Part2Test do
  use ExUnit.Case
  # doctest Aoc2020.Day17.Part2
  import Aoc2020.Day17.Part2

  test "find neighbors" do
    n = find_neighbors_coordinates({0, 0, 1, 1})
    assert Enum.count(n) == 80
  end

  test "find new state" do
    hc = MapSet.new([{0, 1, 0, 0}, {1, 2, 0, 0}, {2, 0, 0, 0}, {2, 1, 0, 0}, {2, 2, 0, 0}])

    p = {1, 0, 0, 0}
    nc = find_neighbors_coordinates(p)
    assert find_new_state(0, hc, nc) == 1

    p2 = {3, 1, 0, 0}
    nc2 = find_neighbors_coordinates(p2)
    assert find_new_state(0, hc, nc2) == 1
  end

  test "example part 2" do
    active = MapSet.new([{0, 1, 0, 0}, {1, 2, 0, 0}, {2, 0, 0, 0}, {2, 1, 0, 0}, {2, 2, 0, 0}])
    l = 0
    r = 3

    assert evolve(%{active: active, l: l, r: r}, 1, 6) == 848
  end
end
