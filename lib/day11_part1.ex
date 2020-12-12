defmodule Aoc2020.Day11.Part1 do
  def solve1 do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day11.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  def part_one_solver(in_seats), do: count_evolutions(in_seats)

  def out_of_map?(m, i, j) do
    num_rows = length(m)
    num_cols = String.length(Enum.at(m, 0))

    j >= num_cols || i >= num_rows || j < 0 || i < 0
  end

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

  def count_evolutions(prev_map) do
    new_map = evolve(prev_map, 0, 0, prev_map)

    # # TODO(gianluca): Remove when done
    # IO.puts("""
    # - prev_map: #{inspect(prev_map, pretty: true)}
    # - new_map: #{inspect(new_map, pretty: true)}

    # """)

    # IO.puts("evolution step: #{cnt}")

    # FIXME(gianluca): cnt is useless :(
    if new_map == prev_map do
      count_occupied_seats(new_map)
    else
      count_evolutions(new_map)
    end
  end

  def count_occupied_seats(m) do
    Enum.reduce(m, 0, fn line, acc ->
      occ =
        String.codepoints(line)
        |> Enum.count(&(&1 == "#"))

      occ + acc
    end)
  end

  def evolve(in_seats, i, j, out_seats) do
    num_rows = length(in_seats)
    num_cols = String.length(Enum.at(in_seats, 0))
    [i_next, j_next] = next_seat(in_seats, i, j)

    # IO.puts("next i: #{i_next}, next j: #{j_next}")

    if (i >= num_rows && j >= num_cols) || i < 0 do
      out_seats
    else
      cond do
        map_at(in_seats, i, j) == "." ->
          # IO.puts("aisle")
          evolve(in_seats, i_next, j_next, out_seats)

        is_free?(in_seats, i, j) && all_around_free?(in_seats, i, j) ->
          new_out_row = make_occupied(out_seats, i, j)
          # new_out_map = List.replace_at(out_seats, i, new_out_row)

          # IO.puts(
          #   "#{inspect(in_seats, pretty: true)} ->
          #           #{Enum.at(out_seats, i)} -> #{new_out_row} -> #{
          #     inspect(new_out_map, pretty: true)
          #   }"
          # )

          evolve(in_seats, i_next, j_next, List.replace_at(out_seats, i, new_out_row))

        is_occupied?(in_seats, i, j) && four_occupied?(in_seats, i, j) ->
          new_out_row = make_free(out_seats, i, j)
          # new_out_map = List.replace_at(out_seats, i, new_out_row)

          # IO.puts(
          #   "#{inspect(in_seats, pretty: true)} ->
          #           #{Enum.at(out_seats, i)} -> #{new_out_row} -> #{
          #     inspect(new_out_map, pretty: true)
          #   }"
          # )

          # IO.puts(
          #   "#{inspect(in_seats, pretty: true)} -> #{Enum.at(out_seats, i)} -> #{new_out_row} -> #{
          #     inspect(new_out_map, pretty: true)
          #   }"
          # )

          evolve(in_seats, i_next, j_next, List.replace_at(out_seats, i, new_out_row))

        true ->
          # IO.puts("#{map_at(in_seats, i, j)} not changed")
          evolve(in_seats, i_next, j_next, out_seats)
      end
    end
  end

  def all_around_free?(m, i, j) do
    surrounding_seats(m, i, j)
    |> Enum.all?(&(&1 == "L" || &1 == "."))
  end

  def surrounding_seats(m, i, j) do
    nw = map_at(m, i - 1, j - 1)
    n = map_at(m, i - 1, j)
    ne = map_at(m, i - 1, j + 1)
    w = map_at(m, i, j - 1)
    e = map_at(m, i, j + 1)
    sw = map_at(m, i + 1, j - 1)
    s = map_at(m, i + 1, j)
    se = map_at(m, i + 1, j + 1)

    x = Enum.filter([nw, n, ne, w, e, sw, s, se], &(&1 != "x"))
    # IO.puts("surrounding #{map_at(m, i, j)}: #{inspect(x, pretty: true)}")
    x
  end

  def four_occupied?(map, i, j) do
    surrounding_seats(map, i, j)
    |> Enum.count(&(&1 == "#")) >= 4
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
end
