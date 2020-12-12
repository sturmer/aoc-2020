defmodule Aoc2020.Day11.Part2 do
  def solve2 do
    parse_and_solve(&part_two_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day11.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  @doc ~S"""
      iex> Aoc2020.Day11.Part2.out_of_map?(["L.LL", "L.L."], 1, 1)
      false

      iex> Aoc2020.Day11.Part2.out_of_map?(["L.LL", "L.L."], 0, -1)
      true

      iex> Aoc2020.Day11.Part2.out_of_map?(["L.LL", "L.L."], -1, -1)
      true

      iex> Aoc2020.Day11.Part2.out_of_map?(["L.LL", "L.L."], 0, 0)
      false

      iex> Aoc2020.Day11.Part2.out_of_map?(["L.LL", "L.L."], 0, 3)
      false

      iex> Aoc2020.Day11.Part2.out_of_map?(["L.LL", "L.L."], 1, 0)
      false

      iex> Aoc2020.Day11.Part2.out_of_map?(["L.LL", "L.L."], 1, 3)
      false
  """
  def out_of_map?(m, i, j) do
    num_rows = length(m)
    num_cols = String.length(Enum.at(m, 0))

    j >= num_cols || i >= num_rows || j < 0 || i < 0
  end

  @doc ~S"""
      iex> Aoc2020.Day11.Part2.next_seat(["L.LL", "L.L."], 0, 0)
      [0, 1]

      iex> Aoc2020.Day11.Part2.next_seat(["L.LL", "L.L."], 0, 1)
      [0, 2]

      iex> Aoc2020.Day11.Part2.next_seat(["L.LL", "L.L."], 0, 3)
      [1, 0]

      iex> Aoc2020.Day11.Part2.next_seat(["L.LL", "L.L."], 1, 3)
      [-1, -1]
  """
  def next_seat(map, i, j) do
    num_rows = length(map)
    num_cols = String.length(Enum.at(map, 0))

    # IO.puts("nr = #{num_rows}, nc = #{num_cols}")

    cond do
      j >= num_cols - 1 && i >= num_rows - 1 ->
        # IO.puts("out of bounds")
        [-1, -1]

      j >= num_cols - 1 && i < num_rows ->
        [i + 1, 0]

      true ->
        [i, j + 1]
    end
  end

  def count_occupied_seats(m) do
    # TODO(gianluca): Remove when done
    # IO.puts("""
    # ------------@@@> #{__MODULE__} | #{Kernel.elem(__ENV__.function, 0)}:#{__ENV__.line}
    # - m: #{inspect(m, pretty: true)})
    # """)

    Enum.reduce(m, 0, fn line, acc ->
      occ =
        String.codepoints(line)
        |> Enum.count(&(&1 == "#"))

      occ + acc
    end)
  end

  def count_evolutions_new_rules(prev_map, cnt) do
    new_map = evolve_one_step(prev_map, 0, 0, prev_map)

    # # TODO(gianluca): Remove when done
    # IO.puts("""
    # - prev_map: #{inspect(prev_map, pretty: true)}
    # - new_map: #{inspect(new_map, pretty: true)}

    # """)

    # IO.puts("step: #{cnt}")

    if new_map == prev_map do
      count_occupied_seats(new_map)
    else
      count_evolutions_new_rules(new_map, cnt + 1)
    end
  end

  def all_around_free?(m, i, j) do
    surrounding_seats(m, i, j)
    |> Enum.all?(&(&1 == "L" || &1 == "."))
  end

  def surrounding_seats(m, i, j) do
    nw = nw_seats(m, i, j)
    n = n_seats(m, i, j)
    ne = ne_seats(m, i, j)
    w = w_seats(m, i, j)
    e = e_seats(m, i, j)
    sw = sw_seats(m, i, j)
    s = s_seats(m, i, j)
    se = se_seats(m, i, j)

    # IO.puts("""
    # surrounding #{map_at(m, i, j)}:
    #   nw: #{inspect(nw, pretty: true)}
    #   n: #{inspect(n, pretty: true)}
    #   ne: #{inspect(ne, pretty: true)}
    #   w: #{inspect(w, pretty: true)}
    #   e: #{inspect(e, pretty: true)}
    #   sw: #{inspect(sw, pretty: true)}
    #   s: #{inspect(s, pretty: true)}
    #   se: #{inspect(se, pretty: true)}
    # """)

    nw ++ n ++ ne ++ w ++ e ++ sw ++ s ++ se
  end

  def dir_seats(orig_sym, m, i, j, delta_i, delta_j, seats) do
    if i < 0 || j < 0 || i > length(m) || j > String.length(Enum.at(m, 0)) do
      seats
    else
      i_next = i + delta_i
      j_next = j + delta_j

      # IO.puts("i_n: #{i_next}, j: #{j_next}")

      next_sym = map_at(m, i_next, j_next)

      cond do
        next_sym == "x" ->
          # IO.puts("got x")
          dir_seats(orig_sym, m, i_next, j_next, delta_i, delta_j, seats)

        next_sym == "." ->
          dir_seats(orig_sym, m, i_next, j_next, delta_i, delta_j, seats)

        # next_sym != orig_sym ->

        true ->
          # stop counting
          [map_at(m, i_next, j_next) | seats]

          # dir_seats(orig_sym, m, i_next, j_next, delta_i, delta_j, seats)
      end
    end
  end

  @doc ~S"""
      iex> Aoc2020.Day11.Part2.nw_seats(["L.L", "L#L", "L.L"], 2, 2)
      ["#"]

      iex> Aoc2020.Day11.Part2.nw_seats(["L.L", "L#L", "L.L"], 1, 1)
      ["L"]

  """
  def nw_seats(m, i, j), do: dir_seats(map_at(m, i, j), m, i, j, -1, -1, [])

  @doc ~S"""
      iex> Aoc2020.Day11.Part2.n_seats(["L.L", "L#L", "L.L"], 2, 2)
      ["L"]

      iex> Aoc2020.Day11.Part2.n_seats(["L.L", "L#L", "L.L"], 1, 1)
      []

      iex> Aoc2020.Day11.Part2.n_seats(["LLL", "L#L", "L.L"], 1, 1)
      ["L"]

      iex> Aoc2020.Day11.Part2.n_seats(["L.L", "L#L", "L.L"], 0, 1)
      []
  """
  def n_seats(m, i, j), do: dir_seats(map_at(m, i, j), m, i, j, -1, 0, [])
  def ne_seats(m, i, j), do: dir_seats(map_at(m, i, j), m, i, j, -1, 1, [])

  @doc ~S"""
      iex> Aoc2020.Day11.Part2.w_seats(["L.L", "L#L", "L.L"], 2, 2)
      ["L"]

      iex> Aoc2020.Day11.Part2.w_seats(["L.L", "L#L", "L.L"], 1, 2)
      ["#"]
  """
  def w_seats(m, i, j), do: dir_seats(map_at(m, i, j), m, i, j, 0, -1, [])
  def e_seats(m, i, j), do: dir_seats(map_at(m, i, j), m, i, j, 0, 1, [])
  def sw_seats(m, i, j), do: dir_seats(map_at(m, i, j), m, i, j, 1, -1, [])
  def s_seats(m, i, j), do: dir_seats(map_at(m, i, j), m, i, j, 1, 0, [])
  def se_seats(m, i, j), do: dir_seats(map_at(m, i, j), m, i, j, 1, 1, [])

  def five_occupied?(map, i, j) do
    surrounding_seats(map, i, j)
    |> Enum.count(&(&1 == "#")) >= 5
  end

  def is_occupied?(map, i, j) do
    map_at(map, i, j) == "#"
  end

  def map_at(map, i, j) do
    if out_of_map?(map, i, j) do
      # IO.puts("(#{i}, #{j}) is out of map")
      "x"
    else
      map
      |> Enum.at(i)
      |> String.at(j)
    end
  end

  def is_free?(map, i, j) do
    map_at(map, i, j) == "L"
  end

  defp change_seat_state(map, i, j, next_state) do
    if out_of_map?(map, i, j) do
      # IO.puts("out of map!")
      Enum.at(map, i)
    else
      Enum.at(map, i)
      |> String.codepoints()
      |> List.replace_at(j, next_state)
      |> List.to_string()
    end
  end

  def make_occupied(map, i, j) do
    change_seat_state(map, i, j, "#")
  end

  def make_free(map, i, j) do
    change_seat_state(map, i, j, "L")
  end

  def part_two_solver(map), do: count_evolutions_new_rules(map, 0)

  def evolve_one_step(in_seats, i, j, out_seats) do
    num_rows = length(in_seats)
    num_cols = String.length(Enum.at(in_seats, 0))
    [i_next, j_next] = next_seat(in_seats, i, j)

    # IO.puts("next i: #{i_next}, next j: #{j_next}")

    if (i >= num_rows && j >= num_cols) || i < 0 do
      out_seats
    else
      cond do
        map_at(in_seats, i, j) == "." ->
          # IO.puts("aisle: #{map_at(in_seats, i, j)}")
          evolve_one_step(in_seats, i_next, j_next, out_seats)

        is_free?(in_seats, i, j) && all_around_free?(in_seats, i, j) ->
          new_out_row = make_occupied(out_seats, i, j)
          new_out_map = List.replace_at(out_seats, i, new_out_row)

          # IO.puts(
          #   "#{inspect(in_seats, pretty: true)} ->
          #           #{Enum.at(out_seats, i)} -> #{new_out_row} -> #{
          #     inspect(new_out_map, pretty: true)
          #   }"
          # )

          evolve_one_step(in_seats, i_next, j_next, new_out_map)

        is_occupied?(in_seats, i, j) && five_occupied?(in_seats, i, j) ->
          new_out_row = make_free(out_seats, i, j)
          new_out_map = List.replace_at(out_seats, i, new_out_row)

          # IO.puts(
          #   "#{inspect(in_seats, pretty: true)} ->
          #           #{Enum.at(out_seats, i)} -> #{new_out_row} -> #{
          #     inspect(new_out_map, pretty: true)
          #   }"
          # )

          evolve_one_step(in_seats, i_next, j_next, new_out_map)

        true ->
          # IO.puts("#{map_at(in_seats, i, j)} not changed")
          evolve_one_step(in_seats, i_next, j_next, out_seats)
      end
    end
  end
end
