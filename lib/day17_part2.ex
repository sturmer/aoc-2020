defmodule Aoc2020.Day17.Part2 do
  def solve do
    parse_and_solve(&part_two_solver/1)
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

  def part_two_solver(lines) do
    r =
      parse_to_hypercube(lines)
      |> List.flatten()
      |> Enum.map(fn {x, y} -> {x, y, 0, 0} end)
      |> MapSet.new()

    hc = %{
      active: r,
      l: 0,
      r: 7
    }

    IO.puts("res: #{evolve(hc, 1, 6)}")
  end

  def count_active(hc) do
    MapSet.size(hc)
  end

  def evolve(hc, cur_iter, max_iter) do
    if cur_iter > max_iter do
      MapSet.size(hc.active)
    else
      # for every point in the upper_left, lower_right extended, check new actives and add them to hc
      new_actives =
        unfold(hc.l, hc.r)
        |> Enum.reduce([], fn c, acc ->
          val = if MapSet.member?(hc.active, c), do: 1, else: 0
          nc = find_neighbors_coordinates(c)
          ns = find_new_state(val, hc.active, nc)

          if ns == 1 do
            [c | acc]
          else
            acc
          end
        end)

      evolve(%{active: MapSet.new(new_actives), l: hc.l - 1, r: hc.r + 1}, cur_iter + 1, max_iter)
    end
  end

  def unfold(l, r) do
    for i <- (l - 1)..(r + 1) do
      for j <- (l - 1)..(r + 1) do
        for k <- (l - 1)..(r + 1) do
          for m <- (l - 1)..(r + 1) do
            {i, j, k, m}
          end
        end
      end
    end
    |> List.flatten()
  end

  def find_new_state(val, hc, nc) do
    counts =
      nc
      |> Enum.reduce(0, fn np, acc ->
        {x, y, z, w} = np

        if is_active?(x, y, z, w, hc) do
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
      iex> hc = MapSet.new([
      ...>    {1, 0},
      ...>    {1, 2},
      ...>    {2, 1},
      ...>    {2, 2},
      ...>    {3, 1}
      ...>  ])
      iex> Aoc2020.Day17.Part2.is_active?(1, 1, 0, hc)
      false
  """
  def is_active?(x, y, z, w, hc) do
    MapSet.member?(hc, {x, y, z, w})
  end

  def find_neighbors_coordinates(p) do
    {x, y, z, w} = p

    for i <- -1..1 do
      for j <- -1..1 do
        for k <- -1..1 do
          for l <- -1..1 do
            {x + i, y + j, z + k, w + l}
          end
        end
      end
    end
    |> List.flatten()
    |> Enum.filter(&(&1 != {x, y, z, w}))
  end
end
