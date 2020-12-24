defmodule Aoc2020.Day16.Part2 do
  alias MatrixReloaded.Matrix

  def solve do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day16.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  @doc """
      iex> Aoc2020.Day16.Part2.parse_from_string("class: 1-3 or 5-7
      ...>      row: 6-11 or 33-44
      ...>      seat: 13-40 or 45-50
      ...>
      ...>      your ticket:
      ...>      7,1,14
      ...>
      ...>      nearby tickets:
      ...>      7,3,47
      ...>      40,4,50
      ...>      55,2,20
      ...>      38,6,12")
      {%{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]},
        [7, 1, 14],
        [[38, 6, 12], [55, 2, 20], [40, 4, 50], [7, 3, 47]]
      }
  """
  def parse_from_string(s) do
    String.split(s, "\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> scan(%{}, [], [], :in_rules_section)
  end

  def part_one_solver(lines) do
    {rules, my_ticket, nearby_tickets} = scan(lines)

    fields_with_candidates =
      extract_valid_tickets(rules, nearby_tickets)
      |> Matrix.transpose()
      |> find_field_order(rules)
      |> Enum.sort(fn {_k1, v1}, {_k2, v2} ->
        length(v1) < length(v2)
      end)

    labels = Enum.map(fields_with_candidates, &elem(&1, 0))
    indices = sieve_out(Enum.map(fields_with_candidates, &elem(&1, 1)))

    Enum.zip(labels, indices)
    |> Enum.filter(fn {label, _rule_idx} ->
      String.match?(label, ~r/^departure/)
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(1, fn g, acc ->
      acc * Enum.at(my_ticket, g)
    end)
  end

  @doc """
    Remove the only element of rule i from rules i+1, i+2, ... n,
    for i = 0..n.

    Input lists must be sorted by ascending length.
      iex> Aoc2020.Day16.Part2.sieve_out([[9], [0, 9], [0, 9, 11]])
      [9, 0, 11]
  """
  def sieve_out(fc, res \\ [])

  def sieve_out([a | fc], res) do
    y =
      Enum.map(fc, fn u ->
        List.delete(u, Enum.at(a, 0))
      end)

    sieve_out(y, [Enum.at(a, 0) | res])
  end

  def sieve_out([], res), do: res |> List.flatten() |> Enum.reverse()

  @doc """
      iex> Aoc2020.Day16.Part2.find_field_order([
      ...>    [11, 33, 34],
      ...>    [6, 1, 5],
      ...>    [18, 15, 49]
      ...>  ],
      ...>  %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      %{"row" => [0], "class" => [1], "seat" => [2]}
  """
  def find_field_order(columns, rules) do
    prepared_rules =
      rules
      |> Enum.reduce(%{}, fn {rule_name, _}, acc ->
        Map.put(acc, rule_name, [])
      end)

    columns
    |> Enum.with_index()
    |> Enum.map(fn {c, idx} ->
      rule_names = find_candidates(rules, c)

      Enum.reduce(rule_names, prepared_rules, fn rn, acc ->
        Map.put(acc, rn, [idx | acc[rn]])
      end)
    end)
    |> Enum.reduce(%{}, fn m, acc ->
      Map.merge(acc, m, fn _k, v1, v2 ->
        v1 ++ v2
      end)
    end)
  end

  @doc """
    What rule names does col satisfy?

      iex> Aoc2020.Day16.Part2.find_candidates(
      ...>  %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]},
      ...>  [11, 33, 34])
      ["row"]

      iex> Aoc2020.Day16.Part2.find_candidates(
      ...>  %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]},
      ...>  [40, 40, 40])
      ["seat", "row"]

  """
  def find_candidates(rules, col) do
    Enum.reduce(rules, [], fn {r_name, ranges}, acc ->
      if is_field?(r_name, ranges, col) do
        [r_name | acc]
      else
        acc
      end
    end)
  end

  @doc """
      iex> Aoc2020.Day16.Part2.is_field?("row",
      ...>  [[6, 11], [33, 44]],
      ...>  [3, 11, 6])
      false

      iex> Aoc2020.Day16.Part2.is_field?("row",
      ...>  [[6, 11], [33, 44]],
      ...>  [7, 11, 40, 8, 6, 42, 35])
      true

    12 does not fall into either range:
      iex> Aoc2020.Day16.Part2.is_field?("row",
      ...>  [[6, 11], [33, 44]],
      ...>  [7, 11, 40, 8, 6, 12, 42, 35])
      false
  """
  def is_field?(_field_name, field_ranges, column) do
    # if (all elements of) column i passes rule j, then that column is of type j

    # Given [[6, 11], [33, 44]], the first row is L0, R0, the second L1, R1.
    with {:ok, l0} <- Matrix.get_element(field_ranges, {0, 0}),
         {:ok, r0} <- Matrix.get_element(field_ranges, {0, 1}),
         {:ok, l1} <- Matrix.get_element(field_ranges, {1, 0}),
         {:ok, r1} <- Matrix.get_element(field_ranges, {1, 1}) do
      column
      |> Enum.all?(&((&1 >= l0 && &1 <= r0) || (&1 >= l1 && &1 <= r1)))
    else
      _ -> IO.puts("error getting matrix elements")
    end
  end

  @doc """
      iex> Aoc2020.Day16.Part2.extract_valid_tickets(
      ...>    %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]],
      ...>        "seat" => [[13, 40], [45, 50]]},
      ...>    [[38, 6, 12], [55, 2, 20], [40, 4, 50], [7, 3, 47]]
      ...>  )
      [[7, 3, 47]]
  """
  def extract_valid_tickets(rules, nearby_tickets, collected \\ [])

  def extract_valid_tickets(rules, [ticket | other_nearby_tickets], collected) do
    # ticket is e.g. [38, 6, 12]
    sum_invalid_values =
      Enum.reduce(ticket, 0, fn val, acc ->
        if in_any_range?(val, rules) do
          acc
        else
          acc + val
        end
      end)

    if sum_invalid_values > 0 do
      extract_valid_tickets(rules, other_nearby_tickets, collected)
    else
      extract_valid_tickets(rules, other_nearby_tickets, [ticket | collected])
    end
  end

  def extract_valid_tickets(_rules, [], collected), do: collected

  @doc """
    6 is in the range 6, 11 (field "row"):
      iex> Aoc2020.Day16.Part2.in_any_range?(6,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      true

    55 doesn't fit into any of the ranges:
      iex> Aoc2020.Day16.Part2.in_any_range?(55,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      false

      iex> Aoc2020.Day16.Part2.in_any_range?(4,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      false

      iex> Aoc2020.Day16.Part2.in_any_range?(50,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      true

      iex> Aoc2020.Day16.Part2.in_any_range?(15,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      true

      iex> Aoc2020.Day16.Part2.in_any_range?(12,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      false
  """
  def in_any_range?(val, rules) do
    Map.values(rules)
    |> Enum.map(&List.flatten/1)
    |> Enum.any?(fn range ->
      (val >= Enum.at(range, 0) && val <= Enum.at(range, 1)) ||
        (val >= Enum.at(range, 2) && val <= Enum.at(range, 3))
    end)
  end

  def scan(lines, rules \\ %{}, my_ticket \\ [], nearby_tickets \\ [], state \\ :in_rules_section)

  def scan([cur_line | more_lines], rules, my_ticket, nearby_tickets, state) do
    cond do
      cur_line == "" ->
        # skip
        scan(more_lines, rules, my_ticket, nearby_tickets, state)

      cur_line != "" ->
        cond do
          cur_line == "your ticket:" ->
            scan(more_lines, rules, my_ticket, nearby_tickets, :in_my_ticket_section)

          cur_line == "nearby tickets:" ->
            # This section is not really needed
            scan(more_lines, rules, my_ticket, nearby_tickets, :in_nearby_tickets_section)

          state == :in_rules_section ->
            # parse rule
            {rule_name, ranges} = parse_rule(cur_line)

            scan(more_lines, Map.put(rules, rule_name, ranges), my_ticket, nearby_tickets, state)

          state == :in_my_ticket_section ->
            # parse my ticket or skip for now
            scan(
              more_lines,
              rules,
              parse_ticket(cur_line),
              nearby_tickets,
              state
            )

          true ->
            # parse nearby ticket
            nb = parse_ticket(cur_line)

            scan(
              more_lines,
              rules,
              my_ticket,
              [nb | nearby_tickets],
              state
            )
        end
    end
  end

  def scan([], rules, my_ticket, nearby_tickets, _state), do: {rules, my_ticket, nearby_tickets}

  @doc """
      iex> Aoc2020.Day16.Part2.parse_ticket("7,1,14")
      [7, 1, 14]
  """
  def parse_ticket(t) do
    String.split(t, ",")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
      iex> Aoc2020.Day16.Part2.parse_rule("bliss: 1-3 or 6-7")
      {"bliss", [[1, 3], [6, 7]]}
  """
  def parse_rule(r) do
    [name, all_ranges] = String.split(r, ":", trim: true)

    ranges =
      String.split(all_ranges, "or", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.map(fn y -> Enum.map(y, &String.to_integer/1) end)

    {name, ranges}
  end
end
