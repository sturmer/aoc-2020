defmodule Day11Part2Test do
  use ExUnit.Case
  doctest Aoc2020.Day11.Part2
  import Aoc2020.Day11.Part2

  test "count example 2" do
    input_map =
      """
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
      """
      |> String.split("\n", trim: true)

    assert count_evolutions_new_rules(input_map, 0) == 26
  end

  test "evolve once" do
    input_map =
      """
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
      """
      |> String.split("\n", trim: true)

    expected =
      """
      #.##.##.##
      #######.##
      #.#.#..#..
      ####.##.##
      #.##.##.##
      #.#####.##
      ..#.#.....
      ##########
      #.######.#
      #.#####.##
      """
      |> String.split("\n", trim: true)

    gotten = evolve_one_step(input_map, 0, 0, input_map)
    assert gotten == expected
  end

  test "evolve once - last step" do
    input_map =
      """
      #.L#.L#.L#
      #LLLLLL.LL
      L.L.L..#..
      ##L#.#L.L#
      L.L#.#L.L#
      #.L####.LL
      ..#.#.....
      LLL###LLL#
      #.LLLLL#.L
      #.L#LL#.L#
      """
      |> String.split("\n", trim: true)

    expected =
      """
      #.L#.L#.L#
      #LLLLLL.LL
      L.L.L..#..
      ##L#.#L.L#
      L.L#.LL.L#
      #.LLLL#.LL
      ..#.L.....
      LLL###LLL#
      #.LLLLL#.L
      #.L#LL#.L#
      """
      |> String.split("\n", trim: true)

    gotten = evolve_one_step(input_map, 0, 0, input_map)
    assert gotten == expected
  end

  test "surrounding_seats_new_rules" do
    m =
      """
      .......#.
      ...#.....
      .#.......
      .........
      ..#L....#
      ....#....
      .........
      #........
      ...#.....
      """
      |> String.split("\n", trim: true)

    res = surrounding_seats(m, 4, 3)
    # IO.puts("res: #{res}")
    assert count_occupied_seats(res) == 8
  end

  test "surrounding_seats_new_rules tricky" do
    m =
      """
      .............
      .L.L.#.#.#.#.
      .............
      """
      |> String.split("\n", trim: true)

    res = surrounding_seats(m, 1, 1)
    # IO.puts("res: #{res}")
    assert count_occupied_seats(res) == 0

    assert count_occupied_seats(surrounding_seats(m, 1, 3)) == 1
    refute five_occupied?(m, 1, 1)
    assert all_around_free?(m, 1, 1)

    m2 =
      """
      .##.##.
      #.#.#.#
      ##...##
      ...L...
      ##...##
      #.#.#.#
      .##.##.
      """
      |> String.split("\n", trim: true)

    res2 = surrounding_seats(m2, 3, 3)
    # IO.puts("res: #{res2}")
    assert count_occupied_seats(res2) == 0
  end

  test "directions" do
    input_map =
      """
      L.LL.LL.LL
      L#LLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
      """
      |> String.split("\n", trim: true)

    nw = nw_seats(input_map, 4, 5)
    # IO.puts("nw: #{inspect(nw, pretty: true)}")
    assert length(nw) == 1
    assert nw == ["L"]

    n = n_seats(input_map, 4, 5)
    # IO.puts("n: #{inspect(n, pretty: true)}")
    assert n == ["L"]
    assert length(n) == 1

    assert n_seats(input_map, 7, 1) == ["L"]
    assert n_seats(input_map, 3, 1) == ["#"]
  end

  @tag :skip
  test "part 2" do
    assert solve() == 2159
  end
end
