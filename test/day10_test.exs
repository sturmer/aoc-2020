defmodule Day10Test do
  use ExUnit.Case
  doctest Aoc2020.Day10
  import Aoc2020.Day10

  test "count arrangements" do
    res =
      """
      16
      10
      15
      5
      1
      11
      7
      19
      6
      12
      4
      0
      22
      """
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort(&(&1 >= &2))
      |> count(%{})

    assert res == 8
  end

  test "count arrangements big" do
    res =
      """
      0
      52
      28
      33
      18
      42
      31
      14
      46
      20
      48
      47
      24
      23
      49
      45
      19
      38
      39
      11
      1
      32
      25
      35
      8
      17
      7
      9
      4
      2
      34
      10
      3
      """
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort(&(&1 >= &2))
      |> count(%{})

    # IO.puts("res: #{res}")
    assert res == 19208
  end

  test "fill diffs" do
    diffs =
      fill_diffs(
        %{},
        """
        16
        10
        15
        5
        1
        11
        7
        19
        6
        12
        4
        """
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sort(&(&1 <= &2)),
        0
      )

    assert Map.get(diffs, 1) == 7
    assert Map.get(diffs, 3) == 5
  end

  test "fill bigger diffs" do
    diffs =
      fill_diffs(
        %{},
        """
        28
        33
        18
        42
        31
        14
        46
        20
        48
        47
        24
        23
        49
        45
        19
        38
        39
        11
        1
        32
        25
        35
        8
        17
        7
        9
        4
        2
        34
        10
        3
        """
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sort(&(&1 <= &2)),
        0
      )

    assert Map.get(diffs, 1) == 22
    assert Map.get(diffs, 3) == 10
  end

  # test "1" do
  #   solve1()
  # end

  # test "" do
  #   solve2()
  # end
end
