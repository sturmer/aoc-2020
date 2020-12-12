defmodule Aoc2020.Day12.Part1 do
  def solve1 do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day12.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  # n, s, w, e
  def part_one_solver(moves), do: find_distance(moves, :east, 0, 0)

  def forward(facing, s, e, amount) do
    case facing do
      :south ->
        [s + amount, e]

      :north ->
        [s - amount, e]

      :east ->
        [s, e + amount]

      :west ->
        [s, e - amount]

      _ ->
        IO.puts("wrong direction")
        exit(:shutdown)
    end
  end

  @doc ~S"""
      iex> Aoc2020.Day12.Part1.rotate_left(:north, 270)
      :east

      iex> Aoc2020.Day12.Part1.rotate_left(:north, 90)
      :west

      iex> Aoc2020.Day12.Part1.rotate_left(:north, 180)
      :south

      iex> Aoc2020.Day12.Part1.rotate_left(:east, 270)
      :south
  """
  def rotate_left(facing, value) do
    steps = div(value, 90)
    dirs = [:north, :west, :south, :east]
    starting_point = Enum.find_index(dirs, &(&1 == facing))
    final_point = rem(starting_point + steps, 4)
    Enum.at(dirs, final_point)
  end

  @doc ~S"""
      iex> Aoc2020.Day12.Part1.rotate_right(:north, 270)
      :west

      iex> Aoc2020.Day12.Part1.rotate_right(:north, 90)
      :east

      iex> Aoc2020.Day12.Part1.rotate_right(:north, 180)
      :south

      iex> Aoc2020.Day12.Part1.rotate_right(:east, 270)
      :north
  """
  def rotate_right(facing, value) do
    steps = div(value, 90)
    dirs = [:north, :east, :south, :west]
    starting_point = Enum.find_index(dirs, &(&1 == facing))
    final_point = rem(starting_point + steps, 4)
    Enum.at(dirs, final_point)
  end

  def find_distance([m | rest_moves], facing, s, e) do
    instr = String.replace(m, ~r/^(\w)(\d+)$/, "\\1")
    value = String.replace(m, ~r/^(\w)(\d+)$/, "\\2") |> String.to_integer()

    case instr do
      "F" ->
        [s, e] = forward(facing, s, e, value)
        find_distance(rest_moves, facing, s, e)

      "N" ->
        [s, e] = forward(:north, s, e, value)
        find_distance(rest_moves, facing, s, e)

      "S" ->
        [s, e] = forward(:south, s, e, value)
        find_distance(rest_moves, facing, s, e)

      "W" ->
        [s, e] = forward(:west, s, e, value)
        find_distance(rest_moves, facing, s, e)

      "E" ->
        [s, e] = forward(:east, s, e, value)
        find_distance(rest_moves, facing, s, e)

      "L" ->
        facing = rotate_left(facing, value)
        find_distance(rest_moves, facing, s, e)

      "R" ->
        facing = rotate_right(facing, value)
        find_distance(rest_moves, facing, s, e)

      _ ->
        IO.puts("bad parsing: #{instr}")
        exit(:shutdown)
    end
  end

  def find_distance([], _facing, s, e), do: manhattan(s, e)

  @doc ~S"""
      iex> Aoc2020.Day12.Part1.manhattan(4, 4)
      8
  """
  def manhattan(s, e) do
    # IO.puts("s: #{s}, e: #{e}")
    abs(s) + abs(e)
  end
end
