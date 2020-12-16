defmodule Aoc2020.Day16.Part1 do
  def solve do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day16.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  @doc """
      iex> Aoc2020.Day16.Part1.parse_from_string("class: 1-3 or 5-7
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
    {rules, _my_ticket, nearby_tickets} = scan(lines, %{}, [], [], :in_rules_section)
    sum_invalid_values(rules, nearby_tickets, 0)
  end

  @doc """
      iex> Aoc2020.Day16.Part1.sum_invalid_values(
      ...>    %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]],
      ...>        "seat" => [[13, 40], [45, 50]]},
      ...>    [[38, 6, 12], [55, 2, 20], [40, 4, 50], [7, 3, 47]],
      ...>    0
      ...>  )
      71
  """
  def sum_invalid_values(rules, [ticket | other_nearby_tickets], sum) do
    # ticket is e.g. [38, 6, 12]
    new_sum =
      Enum.reduce(ticket, 0, fn val, acc ->
        if in_any_range(val, rules) do
          acc
        else
          acc + val
        end
      end)

    sum_invalid_values(rules, other_nearby_tickets, sum + new_sum)
  end

  def sum_invalid_values(_rules, [], sum), do: sum

  @doc """
      iex> Aoc2020.Day16.Part1.in_any_range(6,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      true

      iex> Aoc2020.Day16.Part1.in_any_range(55,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      false

      iex> Aoc2020.Day16.Part1.in_any_range(4,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      false

      iex> Aoc2020.Day16.Part1.in_any_range(50,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      true

      iex> Aoc2020.Day16.Part1.in_any_range(15,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      true

      iex> Aoc2020.Day16.Part1.in_any_range(12,
      ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
      false
  """
  def in_any_range(val, rules) do
    Map.values(rules)
    |> Enum.map(&List.flatten/1)
    |> Enum.any?(fn range ->
      (val >= Enum.at(range, 0) && val <= Enum.at(range, 1)) ||
        (val >= Enum.at(range, 2) && val <= Enum.at(range, 3))
    end)
  end

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
      iex> Aoc2020.Day16.Part1.parse_ticket("7,1,14")
      [7, 1, 14]
  """
  def parse_ticket(t) do
    # |> Enum.map(&String.trim/1)
    String.split(t, ",")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
      iex> Aoc2020.Day16.Part1.parse_rule("bliss: 1-3 or 6-7")
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
