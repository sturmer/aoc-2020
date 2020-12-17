defmodule Aoc2020.Day17.Part1 do
  def solve do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day17.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  # @doc """
  #     iex> Aoc2020.Day17.Part1.parse_from_string("
  #     ...>  .#.
  #     ...>  ..#
  #     ...>  ###")
  #     [
  #       {0, 0, :off}, {0, 1, :on}, {0, 2, :off},
  #       {1, 0, :off}, {1, 1, :off}, {1, 2, :on},
  #       {2, 0, :on}, {2, 1, :on}, {2, 2, :on}
  #     ]
  # """
  def parse_from_string(s) do
    String.split(s, "\n", trim: true)
    |> Enum.map(&String.trim/1)
    # [".#.", "..#", "###"]
    |> Enum.with_index()
    # [{".#.", 0}, {"..#", 1}, {"###", 2}]
    |> Enum.map(fn rec ->
      line = elem(rec, 0)
      x = elem(rec, 1)
      to_cell_description(line, x)
    end)

    # |> evolve(0, 6)
  end

  @doc """
      iex> Aoc2020.Day17.Part1.to_cell_description(".#.", 0)
      [{0, 0, :off}, {0, 1, :on}, {0, 2, :off}]

      iex> Aoc2020.Day17.Part1.to_cell_description(".#.", 1)
      [{1, 0, :off}, {1, 1, :on}, {1, 2, :off}]
  """
  def to_cell_description(str, x) do
    String.codepoints(str)
    |> Enum.with_index()
    |> Enum.map(fn rec ->
      symbol = elem(rec, 0)
      y = elem(rec, 1)

      if symbol == "." do
        {x, y, :off}
      else
        {x, y, :on}
      end
    end)
  end

  def part_one_solver(lines) do
  end

  # NOTE(gianluca):
  # The 2D matrix for z == i is the same as the one for z == -i =>
  # Only recompute for 0..z, then compute for z+1.
  # After iteration 1, the 2d matrix acquires 2 rows and 2 columns.
  # @doc ~S"""
  #     iex> Aoc2020.Day17.Part1.evolve([
  #     ...>  {0,
  #     ...>    [{0, 0, :off}, {0, 1, :on}, {0, 2, :off}],
  #     ...>    [{1, 0, :off}, {1, 1, :on}, {1, 2, :off}],
  #     ...>    [{2, 0, :off}, {2, 1, :on}, {2, 2, :off}]
  #     ...>  }
  #     ...>  ], 0, 1)
  #     [
  #       {0,
  #         [{0, 0, :on}, {0, 1, :off}, {0, 2, :on}],
  #         [{1, 0, :off}, {1, 1, :on}, {1, 2, :on}],
  #         [{2, 0, :off}, {2, 1, :on}, {2, 2, :off}]
  #       },

  #       {1,
  #         [{0, 0, :on}, {0, 1, :off}, {0, 2, :off}],
  #         [{1, 0, :off}, {1, 1, :off}, {1, 2, :on}],
  #         [{2, 0, :off}, {2, 1, :on}, {2, 2, :off}]
  #       },
  #     ]
  # """
  # def evolve(grid, cur_iter, max_iter) do
  #   if cur_iter >= max_iter do
  #     grid
  #   else
  #     z = elem(grid, 0)
  #     slice = elem(grid, 1)

  #     Enum.reduce(slice, fn row ->
  #       neighbors = Enum.map(row, &find_neighbors/1)
  #     end)
  #   end
  # end

  @doc ~S"""
      iex> neighbors = Aoc2020.Day17.Part1.find_neighbors({0, {0, 0, :off}})
      iex> Enum.count(neighbors)
      11
      iex> neighbors
      [
        {0, {1, 0}}, {0, {1, 1}}, {0, {0, 1}},
        {-1, {0, 0}}, {-1, {1, 0}}, {-1, {1, 1}}, {-1, {0, 1}},
        {1, {0, 0}}, {1, {1, 0}}, {1, {1, 1}}, {1, {0, 1}}
      ]

      iex> n = Aoc2020.Day17.Part1.find_neighbors({0, {1, 1, :off}})
      iex> Enum.count(n)
      26
      iex> n
      [
        {0, {0, 1}}, {0, {0, 0}}, {0, {1, 0}}, {0, {2, 0}}, {0, {2, 1}}, {0, {2, 2}},
          {0, {1, 2}}, {0, {0, 2}},
        {-1, {1, 1}}, {-1, {0, 1}}, {-1, {0, 0}}, {-1, {1, 0}},
          {-1, {2, 0}}, {-1, {2, 1}}, {-1, {2, 2}}, {-1, {1, 2}}, {-1, {0, 2}},
        {1, {1, 1}}, {1, {0, 1}}, {1, {0, 0}}, {1, {1, 0}}, {1, {2, 0}}, {1, {2, 1}},
          {1, {2, 2}}, {1, {1, 2}}, {1, {0, 2}}
      ]
  """
  def find_neighbors(p) do
    # p is {z, {x, y}}
    {z, {x, y, _}} = p
    add_same_plane(z, x, y) ++ add_plane(z - 1, x, y) ++ add_plane(z + 1, x, y)
  end

  @doc ~S"""
      iex> Aoc2020.Day17.Part1.add_same_plane(1, 1, 1)
      [
        {1, {0, 1}}, {1, {0, 0}}, {1, {1, 0}}, {1, {2, 0}},
        {1, {2, 1}}, {1, {2, 2}}, {1, {1, 2}}, {1, {0, 2}}
      ]

      iex> Aoc2020.Day17.Part1.add_same_plane(-1, 0, 0)
      [{-1, {1, 0}}, {-1, {1, 1}}, {-1, {0, 1}}]

      iex> Aoc2020.Day17.Part1.add_same_plane(-1, 0, 1)
      [{-1, {0, 0}}, {-1, {1, 0}}, {-1, {1, 1}}, {-1, {1, 2}}, {-1, {0, 2}}]
  """
  def add_same_plane(z, x, y) do
    [
      # north
      {z, {x - 1, y}},

      # north-west
      {z, {x - 1, y - 1}},

      # west
      {z, {x, y - 1}},

      # south-west
      {z, {x + 1, y - 1}},

      # south
      {z, {x + 1, y}},

      # south-east
      {z, {x + 1, y + 1}},

      # east
      {z, {x, y + 1}},

      # north-east
      {z, {x - 1, y + 1}}
    ]
    |> Enum.filter(fn p ->
      xy = elem(p, 1)
      x0 = elem(xy, 0)
      y0 = elem(xy, 1)
      x0 >= 0 && y0 >= 0 && !(x0 == x && y0 == y)
    end)
  end

  @doc ~S"""
      iex> Aoc2020.Day17.Part1.add_plane(1, 1, 1)
      [
        {1, {1, 1}}, {1, {0, 1}}, {1, {0, 0}}, {1, {1, 0}},
        {1, {2, 0}}, {1, {2, 1}}, {1, {2, 2}}, {1, {1, 2}}, {1, {0, 2}}
      ]

      iex> Aoc2020.Day17.Part1.add_plane(-1, 0, 0)
      [{-1, {0, 0}}, {-1, {1, 0}}, {-1, {1, 1}}, {-1, {0, 1}}]

      iex> Aoc2020.Day17.Part1.add_plane(-1, 0, 1)
      [{-1, {0, 1}}, {-1, {0, 0}}, {-1, {1, 0}}, {-1, {1, 1}}, {-1, {1, 2}}, {-1, {0, 2}}]
  """
  def add_plane(z, x, y) do
    [
      # same
      {z, {x, y}},

      # north
      {z, {x - 1, y}},

      # north-west
      {z, {x - 1, y - 1}},

      # west
      {z, {x, y - 1}},

      # south-west
      {z, {x + 1, y - 1}},

      # south
      {z, {x + 1, y}},

      # south-east
      {z, {x + 1, y + 1}},

      # east
      {z, {x, y + 1}},

      # north-east
      {z, {x - 1, y + 1}}
    ]
    |> Enum.filter(fn p ->
      xy = elem(p, 1)
      x0 = elem(xy, 0)
      y0 = elem(xy, 1)

      x0 >= 0 && y0 >= 0
    end)
  end
end
