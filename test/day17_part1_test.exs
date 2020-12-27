defmodule Day17Part1Test do
  use ExUnit.Case
  alias Aoc2020.Hyperplane
  doctest Aoc2020.Day17.Part1
  import Aoc2020.Day17.Part1

  # TODO(gianluca): for fun use Hypercube
  @hc_at_time_0 %{
    0 => %Hyperplane{
      active:
        MapSet.new([
          {0, 1},
          {1, 2},
          {2, 0},
          {2, 1},
          {2, 2}
        ]),
      upper_left: {0, 0},
      lower_right: {2, 2}
    }
  }

  @hc_at_time_1 %{
    -1 => %Hyperplane{
      active:
        MapSet.new([
          {1, 0},
          {2, 2},
          {3, 1}
        ]),
      upper_left: {-1, -1},
      lower_right: {3, 3}
    },
    0 => %Hyperplane{
      active:
        MapSet.new([
          {1, 0},
          {1, 2},
          {2, 1},
          {2, 2},
          {3, 1}
        ]),
      upper_left: {-1, -1},
      lower_right: {3, 3}
    },
    1 => %Hyperplane{
      active:
        MapSet.new([
          {1, 0},
          {2, 2},
          {3, 1}
        ]),
      upper_left: {-1, -1},
      lower_right: {3, 3}
    }
  }

  @hc_at_time_2 %{
    -2 => %Hyperplane{
      active: MapSet.new([{2, 1}]),
      upper_left: {-2, -2},
      lower_right: {4, 4}
    },
    -1 => %Hyperplane{
      active: MapSet.new([{0, 1}, {1, 0}, {1, 3}, {2, 3}, {3, 0}]),
      upper_left: {-2, -2},
      lower_right: {4, 4}
    },
    0 => %Hyperplane{
      active:
        MapSet.new([{0, -1}, {0, 0}, {1, -1}, {1, 0}, {2, -1}, {3, 3}, {4, 0}, {4, 1}, {4, 2}]),
      upper_left: {-2, -2},
      lower_right: {4, 4}
    },
    1 => %Hyperplane{
      active: MapSet.new([{0, 1}, {1, 0}, {1, 3}, {2, 3}, {3, 0}]),
      upper_left: {-2, -2},
      lower_right: {4, 4}
    },
    2 => %Hyperplane{
      active: MapSet.new([{2, 1}]),
      upper_left: {-2, -2},
      lower_right: {4, 4}
    }
  }

  test "find new state" do
    p = {0, {0, 1}}
    nc = find_neighbors_coordinates(p)
    active = MapSet.new([{0, 1}, {1, 2}, {2, 0}, {2, 1}, {2, 2}])
    hc = %{0 => %Hyperplane{active: active}}
    assert find_new_state(0, hc, nc) == 0
  end

  test "new activation of plane 0, element deactivates" do
    test_activation([{0, {2, 2}}], 0)
  end

  test "activation plane 0 at time 2" do
    test_activation([{0, {0, 1}}], 0, @hc_at_time_1)
    test_activation([{0, {0, 0}}], 1, @hc_at_time_1)
  end

  test "activation of plane 1, element activates" do
    test_activation([{1, {2, 2}}, {1, {1, 0}}, {1, {3, 1}}], 1)
  end

  test "activation of plane 0, element activates" do
    test_activation([{0, {3, 1}}], 1)
  end

  test "activation of plane 1, elements stay inactive" do
    test_activation(
      [
        {1, {0, 0}},
        {1, {0, 1}},
        {1, {0, 2}},
        {1, {0, 3}},
        {1, {1, 1}},
        {1, {1, 2}},
        {1, {1, 3}},
        {1, {2, 0}},
        {1, {2, 1}},
        {1, {2, 3}},
        {1, {3, 0}},
        {1, {3, 2}},
        {1, {3, 3}}
      ],
      0
    )
  end

  test "evolve" do
    assert evolve(@hc_at_time_0, 0, 0) == count_active(@hc_at_time_1)
  end

  test "evolve plane" do
    assert evolve_plane(@hc_at_time_0, 0) == @hc_at_time_1[0]
  end

  test "evolve plane z=0 from t=1 to t=2" do
    evolved = evolve_plane(@hc_at_time_1, 0)
    assert evolved = @hc_at_time_2[0]
  end

  test "evolve plane z=2 from t=1 to t=2" do
    z = 2
    evolved = evolve_plane(@hc_at_time_1, z)
    assert evolved = @hc_at_time_2[z]
  end

  test "part 1" do
    assert solve() == 232
  end

  test "example from problem statement" do
    cnt = evolve(@hc_at_time_0, 1, 6)
    assert cnt == 112
  end

  defp test_activation(ps, expected_state, hc \\ @hc_at_time_0) do
    ps
    |> Enum.each(fn p ->
      nc = find_neighbors_coordinates(p)

      assert find_new_state(0, hc, nc) == expected_state
    end)
  end
end
