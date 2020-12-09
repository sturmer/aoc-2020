defmodule Day09Test do
  use ExUnit.Case
  doctest Aoc2020.Day09
  import Aoc2020.Day09

  test "find weakness" do
    stream =
      """
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
      """
      |> String.split("\n", trim: true)

    assert weakness(stream, 5) == 127
  end

  # test "solve 1" do
  #   # 69_316_178
  #   solve1()
  # end

  test "find smauerg" do
    stream =
      """
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
      """
      |> String.split("\n", trim: true)

    assert sumset_master(stream, 127) == 62
  end

  test "solve 2" do
    solve2()
  end
end
