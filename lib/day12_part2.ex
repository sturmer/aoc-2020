defmodule Aoc2020.Day12.Part2 do
  @opposite %{:north => :south, :south => :north, :east => :west, :west => :east}

  def solve do
    parse_and_solve(&part_two_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day12.input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn <<instr, value::binary>> ->
      {<<instr>>, String.to_integer(value)}
    end)
    |> fun.()
  end

  def part_two_solver(moves), do: find_distance(moves, %{east: 10, north: 1}, 0, 0)

  @doc ~S"""
      iex> Aoc2020.Day12.Part2.forward({38, 170}, %{east: 4, south: 10}, 11)
      {-72, 214}

      iex> Aoc2020.Day12.Part2.forward({10, 100}, %{north: 4, east: 10}, 7)
      {38, 170}
  """
  def forward(pos, wp, amount) do
    # Move ship, not waypoint.
    # pos: {n, e}
    # wp: %{north: amt, east: amt}

    # multiply all amounts in the map by amount
    mag =
      Map.keys(wp)
      |> Enum.reduce(wp, fn x, acc ->
        %{acc | :"#{x}" => Map.get(acc, x) * amount}
      end)

    # IO.puts("mag: #{inspect(mag, pretty: true)}")

    Map.keys(mag)
    |> Enum.reduce(pos, fn k, acc ->
      case k do
        :north ->
          {elem(acc, 0) + Map.get(mag, k), elem(acc, 1)}

        :south ->
          {elem(acc, 0) - Map.get(mag, k), elem(acc, 1)}

        :east ->
          {elem(acc, 0), elem(acc, 1) + Map.get(mag, k)}

        :west ->
          {elem(acc, 0), elem(acc, 1) - Map.get(mag, k)}

        true ->
          IO.puts("may day, may day")
          exit(:shutdown)
      end
    end)
  end

  @doc ~S"""
      iex> Aoc2020.Day12.Part2.rotate(%{north: 4, east: 10}, :right, 90)
      %{east: 4, south: 10}

      iex> Aoc2020.Day12.Part2.rotate(%{east: 4, south: 10}, :left, 90)
      %{north: 4, east: 10}
  """
  def rotate(wp, dir, value) do
    steps = div(value, 90)

    dirs =
      if dir == :right do
        [:north, :east, :south, :west]
      else
        [:north, :west, :south, :east]
      end

    [dir1, dir2] = Map.keys(wp)
    starting_point1 = Enum.find_index(dirs, &(&1 == dir1))
    new_idx1 = rem(starting_point1 + steps, 4)
    new_dir1 = Enum.at(dirs, new_idx1)
    # IO.puts("starting_point1: #{starting_point1}, new_idx1: #{new_idx1}, new_dir1: #{new_dir1}")

    starting_point2 = Enum.find_index(dirs, &(&1 == dir2))
    new_idx2 = rem(starting_point2 + steps, 4)
    new_dir2 = Enum.at(dirs, new_idx2)
    # IO.puts("starting_point2: #{starting_point2}, new_idx2: #{new_idx2}, new_dir2: #{new_dir2}")

    %{:"#{new_dir1}" => Map.get(wp, dir1), :"#{new_dir2}" => Map.get(wp, dir2)}
  end

  @doc ~S"""
      iex> Aoc2020.Day12.Part2.rotate_right(%{north: 4, east: 10}, 90)
      %{east: 4, south: 10}
  """
  def rotate_right(wp, value), do: rotate(wp, :right, value)

  @doc ~S"""
      iex> Aoc2020.Day12.Part2.rotate_left(%{east: 4, south: 10}, 90)
      %{north: 4, east: 10}
  """
  def rotate_left(wp, value), do: rotate(wp, :left, value)

  def opposite(dir) do
    Map.get(@opposite, dir)
  end

  @doc ~S"""
      iex> Aoc2020.Day12.Part2.move_waypoint(%{north: 1, east: 10}, :north, 3)
      %{north: 4, east: 10}

      iex> Aoc2020.Day12.Part2.move_waypoint(%{north: 1, east: 10}, :south, 3)
      %{north: -2, east: 10}
  """
  def move_waypoint(wp, dir, val) do
    if Map.has_key?(wp, dir) do
      %{wp | dir => Map.get(wp, dir) + val}
    else
      %{wp | opposite(dir) => Map.get(wp, opposite(dir)) - val}
    end
  end

  def find_distance([m | rest_moves], wp, s, e) do
    {instr, value} = m
    translate = %{"N" => :north, "S" => :south, "E" => :east, "W" => :west}
    lrmap = %{"L" => :left, "R" => :right}

    cond do
      instr == "F" ->
        {s, e} = forward({s, e}, wp, value)
        find_distance(rest_moves, wp, s, e)

      String.match?(instr, ~r/^[NSWE]$/) ->
        wp = move_waypoint(wp, Map.get(translate, instr), value)
        find_distance(rest_moves, wp, s, e)

      String.match?(instr, ~r/^[LR]$/) ->
        wp = rotate(wp, Map.get(lrmap, instr), value)
        find_distance(rest_moves, wp, s, e)

      true ->
        IO.puts("bad parsing: #{instr}")
        exit(:shutdown)
    end
  end

  def find_distance([], _wp, s, e), do: manhattan(s, e)

  # FIXME(gianluca): factor out. Create helpers. Or library (plug? hex?).
  @doc ~S"""
      iex> Aoc2020.Day12.Part1.manhattan(4, 4)
      8
  """
  def manhattan(s, e) do
    # IO.puts("s: #{s}, e: #{e}")
    abs(s) + abs(e)
  end
end
