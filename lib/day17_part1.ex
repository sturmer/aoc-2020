defmodule Aoc2020.Day17.Part1 do
  alias Aoc2020.Hyperplane

  def solve do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day17.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  def parse_to_hypercube(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, i}, acc ->
      [{i, String.codepoints(row) |> Enum.with_index()} | acc]
    end)
    |> Enum.reduce([], fn {i, pts}, acc ->
      j_acc =
        Enum.reduce(pts, [], fn {val, j}, acc_j ->
          if val == "#" do
            [{i, j} | acc_j]
          else
            acc_j
          end
        end)

      [j_acc | acc]
    end)
  end

  def part_one_solver(lines) do
    r = parse_to_hypercube(lines) |> List.flatten()

    hc = %{
      0 => %Hyperplane{
        active: MapSet.new(r),
        upper_left: {0, 0},
        lower_right: {7, 7}
      }
    }

    evolve(hc, 1, 6)
  end

  @doc """
      iex> Aoc2020.Day17.Part1.count_active(%Hyperplane{
      ...>    active: MapSet.new([{0, 1}, {1, 0}, {1, 3}, {2, 3}, {3, 0}]),
      ...>    upper_left: {-2, -2},
      ...>    lower_right: {4, 4}
      ...>  })
      5
  """
  def count_active(%Hyperplane{} = hc) do
    MapSet.size(hc.active)
  end

  def count_active(hc) do
    hc
    |> Enum.reduce(0, fn {_z, hp}, acc ->
      acc + count_active(hp)
    end)
  end

  @doc ~S"""
    The 2D matrix for z == i is the same as the one for z == -i.
  """
  def evolve(hc, cur_iter, max_iter) do
    if cur_iter > max_iter do
      count_active(hc)
    else
      farthest_plane_idx = div(Enum.count(hc), 2) + 1

      -farthest_plane_idx..farthest_plane_idx
      |> Enum.reduce(%{}, fn idx, acc ->
        new_plane = evolve_plane(hc, idx)
        Map.put(acc, idx, new_plane)
      end)
      |> evolve(cur_iter + 1, max_iter)
    end
  end

  def evolve_plane(hc, z) do
    if !Map.has_key?(hc, z) do
      new_plane = %Hyperplane{upper_left: hc[0].upper_left, lower_right: hc[0].lower_right}

      evolve_plane(Map.merge(hc, %{z => new_plane}), z)
    else
      # for every element of grid, get active neighbors and the counts

      inactive =
        unfold_plane(hc[z].upper_left, hc[z].lower_right)
        |> Enum.reduce(%{}, fn p, acc ->
          Map.put(acc, p, 0)
        end)

      active =
        MapSet.to_list(hc[z].active)
        |> Enum.reduce(%{}, fn p, acc ->
          Map.put(acc, p, 1)
        end)

      new_active =
        Map.merge(inactive, active)
        |> Enum.reduce(%{}, fn {p, val}, acc ->
          {x, y} = p
          np = find_neighbors_coordinates({z, {x, y}})
          new_state = find_new_state(val, hc, np)

          if new_state == 1 do
            Map.put(acc, {x, y}, 1)
          else
            Map.put(acc, {x, y}, 0)
          end
        end)
        |> Enum.map(fn {p, val} -> if val == 1, do: p, else: nil end)
        |> Enum.filter(&(&1 != nil))
        |> MapSet.new()

      # retransform back into hyperplane
      %Hyperplane{
        active: new_active,
        upper_left: {elem(hc[z].upper_left, 0) - 1, elem(hc[z].upper_left, 0) - 1},
        lower_right: {elem(hc[z].lower_right, 0) + 1, elem(hc[z].lower_right, 1) + 1}
      }
    end
  end

  def unfold_plane(upper_left, lower_right) do
    {x0, _y0} = upper_left
    {u, _v} = lower_right

    for i <- (x0 - 1)..(u + 1) do
      for j <- (x0 - 1)..(u + 1) do
        {i, j}
      end
    end
    |> List.flatten()
  end

  @doc """
    hc stands for "Hypercube". Its shape:
      %{z_dimension => %Hyperplane{}}

    nc stands for "neighbor coordinates".

      iex> p = {0, {0, 1}}
      iex> nc = Aoc2020.Day17.Part1.find_neighbors_coordinates(p)
      iex> active = MapSet.new([{0, 1}, {1, 2}, {2, 0}, {2, 1}, {2, 2}])
      iex> hc = %{0 => %Hyperplane{active: active}}
      iex> Aoc2020.Day17.Part1.find_new_state(0, hc, nc)
      0
  """
  def find_new_state(val, hc, nc) do
    counts =
      nc
      |> Enum.reduce(0, fn np, acc ->
        {z, {x, y}} = np

        # val = grid[x, y]
        if is_active?(x, y, z, hc) do
          # if z == 1, do: IO.puts("Active neighbor: (#{x}, #{y}, #{z})")
          acc + 1
        else
          acc
        end
      end)

    case val do
      1 ->
        if counts == 2 || counts == 3 do
          1
        else
          0
        end

      0 ->
        if counts == 3 do
          1
        else
          0
        end
    end
  end

  @doc """
      iex> active = MapSet.new([
      ...>    {1, 0},
      ...>    {1, 2},
      ...>    {2, 1},
      ...>    {2, 2},
      ...>    {3, 1}
      ...>  ])
      iex> hc = %{0 => %Hyperplane{upper_left: {0, 0}, lower_right: {3, 3}, active: active}}
      iex> Aoc2020.Day17.Part1.is_active?(1, 1, 0, hc)
      false
  """
  def is_active?(x, y, z, hc) do
    Map.has_key?(hc, z) && MapSet.member?(hc[z].active, {x, y})
  end

  @doc ~S"""
      iex> n = Aoc2020.Day17.Part1.find_neighbors_coordinates({0, {1, 1}})
      iex> Enum.count(n)
      26
      iex> n
      [
        {0, {2, 2}}, {0, {2, 1}}, {0, {2, 0}}, {0, {1, 2}}, {0, {1, 0}},
        {0, {0, 2}}, {0, {0, 1}}, {0, {0, 0}}, {-1, {2, 2}}, {-1, {2, 1}},
        {-1, {2, 0}}, {-1, {1, 2}}, {-1, {1, 1}}, {-1, {1, 0}}, {-1, {0, 2}},
        {-1, {0, 1}}, {-1, {0, 0}}, {1, {2, 2}}, {1, {2, 1}}, {1, {2, 0}},
        {1, {1, 2}}, {1, {1, 1}}, {1, {1, 0}}, {1, {0, 2}}, {1, {0, 1}}, {1, {0, 0}}
      ]
  """
  def find_neighbors_coordinates(p) do
    {z, {x, y}} = p
    add_same_plane(z, x, y) ++ add_plane(z - 1, x, y) ++ add_plane(z + 1, x, y)
  end

  @doc ~S"""
      iex> Aoc2020.Day17.Part1.add_same_plane(1, 1, 1)
      [
        {1, {2, 2}}, {1, {2, 1}}, {1, {2, 0}}, {1, {1, 2}},
        {1, {1, 0}}, {1, {0, 2}}, {1, {0, 1}}, {1, {0, 0}}
      ]

      iex> Aoc2020.Day17.Part1.add_same_plane(-1, 0, 0)
      [
        {-1, {1, 1}}, {-1, {1, 0}}, {-1, {1, -1}}, {-1, {0, 1}},
        {-1, {0, -1}}, {-1, {-1, 1}}, {-1, {-1, 0}}, {-1, {-1, -1}}
      ]

      iex> Aoc2020.Day17.Part1.add_same_plane(-1, 0, 1)
      [
        {-1, {1, 2}}, {-1, {1, 1}}, {-1, {1, 0}}, {-1, {0, 2}},
        {-1, {0, 0}}, {-1, {-1, 2}}, {-1, {-1, 1}}, {-1, {-1, 0}}
      ]
  """
  def add_same_plane(z, x, y) do
    -1..1
    |> Enum.reduce([], fn i, acc_i ->
      el =
        -1..1
        |> Enum.reduce([], fn j, acc_j ->
          if i == 0 && j == 0 do
            acc_j
          else
            [{z, {x + i, y + j}} | acc_j]
          end
        end)

      [el | acc_i]
    end)
    |> List.flatten()
  end

  @doc ~S"""
      iex> Aoc2020.Day17.Part1.add_plane(1, 1, 1)
      [
        {1, {2, 2}}, {1, {2, 1}}, {1, {2, 0}}, {1, {1, 2}},
        {1, {1, 1}}, {1, {1, 0}}, {1, {0, 2}}, {1, {0, 1}}, {1, {0, 0}}
      ]

      iex> Aoc2020.Day17.Part1.add_plane(-1, 0, 0)
      [
        {-1, {1, 1}}, {-1, {1, 0}}, {-1, {1, -1}}, {-1, {0, 1}}, {-1, {0, 0}},
        {-1, {0, -1}}, {-1, {-1, 1}}, {-1, {-1, 0}}, {-1, {-1, -1}}
      ]

      iex> Aoc2020.Day17.Part1.add_plane(-1, 0, 1)
      [
        {-1, {1, 2}}, {-1, {1, 1}}, {-1, {1, 0}}, {-1, {0, 2}},
        {-1, {0, 1}}, {-1, {0, 0}}, {-1, {-1, 2}}, {-1, {-1, 1}}, {-1, {-1, 0}}
      ]
  """
  def add_plane(z, x, y) do
    -1..1
    |> Enum.reduce([], fn i, acc_i ->
      el =
        -1..1
        |> Enum.reduce([], fn j, acc_j ->
          [{z, {x + i, y + j}} | acc_j]
        end)

      [el | acc_i]
    end)
    |> List.flatten()
  end
end
