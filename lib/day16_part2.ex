defmodule Aoc2020.Day16.Part2 do
  def solve do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day16.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  #   @doc """
  #       iex> Aoc2020.Day16.Part2.parse_from_string("class: 1-3 or 5-7
  #       ...>      row: 6-11 or 33-44
  #       ...>      seat: 13-40 or 45-50
  #       ...>
  #       ...>      your ticket:
  #       ...>      7,1,14
  #       ...>
  #       ...>      nearby tickets:
  #       ...>      7,3,47
  #       ...>      40,4,50
  #       ...>      55,2,20
  #       ...>      38,6,12")
  #       {%{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]},
  #         [7, 1, 14],
  #         [[38, 6, 12], [55, 2, 20], [40, 4, 50], [7, 3, 47]]
  #       }
  #   """
  #   def parse_from_string(s) do
  #     String.split(s, "\n", trim: true)
  #     |> Enum.map(&String.trim/1)
  #     |> scan(%{}, [], [], :in_rules_section)
  #   end

  def part_one_solver(lines) do
    # {rules, _my_ticket, nearby_tickets} = scan(lines, %{}, [], [], :in_rules_section)
    # remaining_tickets = discard_invalid_tickets(rules, nearby_tickets, [])

    # # for each idx, get indices of all tickets and check which field they belong to.
    # field_order = find_field_order(remaining_tickets, rules, %{})
  end

  #   @doc """
  #       iex> Aoc2020.Day16.Part2.find_field_order([{0, [3, 15, 5]}, {1, [9, 1, 14]}, {2, [18, 5, 9]}],
  #       ...>  %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]},
  #       ...>  %{})
  #       %{"row" => 0, "class" => 1, "seat" => 2}
  #   """
  #   def find_field_order([c | other_columns], rules, map) do
  #     x =
  #       Map.keys(rules)
  #       |> Enum.reduce(%{}, fn k, acc ->
  #         if is_field(elem(c, 1), Map.get(rules, k)) do
  #           {k, elem(c, 0)}
  #         else
  #           acc
  #         end
  #       end)

  #     # x is %{"class" => 1}

  #     find_field_order(other_columns, rules, Map.put(map, elem(x, 0), elem(x, 1)))
  #   end

  #   def find_field_order([], _rules, map), do: map

  #   @doc """
  #       iex> Aoc2020.Day16.Part2.get_column(0, [[3,9,18],[15,1,5],[5,14,9]])
  #       {0, [3, 15, 5]}

  #       iex> Aoc2020.Day16.Part2.get_column(2, [[3,9,18],[15,1,5],[5,14,9]])
  #       {2, [18, 5, 9]}
  #   """
  #   def get_column(i, values) do
  #     {i, Enum.map(values, &Enum.at(&1, i))}
  #   end

  #   @doc """
  #       iex> Aoc2020.Day16.Part2.is_field([3, 15, 5], "row", [[6, 11], [33, 44]])
  #       false

  #       iex> Aoc2020.Day16.Part2.is_field([[3,9,18],[15,1,5],[5,14,9]], "class", [[1, 3], [5, 7]])
  #       true
  #   """
  #   def is_field(values, field_ranges) do
  #     # if elem 0 of all valid tickets passes rule i, then that field is of type rule name
  #     flat = List.flatten(field_ranges)

  #     Enum.all?(
  #       values,
  #       &((&1 >= Enum.at(flat, 0) && &1 <= Enum.at(flat, 1)) ||
  #           (&1 >= Enum.at(flat, 2) && &1 <= Enum.at(flat, 3)))
  #     )
  #   end

  #   @doc """
  #       iex> Aoc2020.Day16.Part2.discard_invalid_tickets(
  #       ...>    %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]],
  #       ...>        "seat" => [[13, 40], [45, 50]]},
  #       ...>    [[38, 6, 12], [55, 2, 20], [40, 4, 50], [7, 3, 47]],
  #       ...>    []
  #       ...>  )
  #       [[7, 3, 47]]
  #   """
  #   def discard_invalid_tickets(rules, [ticket | other_nearby_tickets], collected) do
  #     # ticket is e.g. [38, 6, 12]
  #     sum_invalid_values =
  #       Enum.reduce(ticket, 0, fn val, acc ->
  #         if in_any_range(val, rules) do
  #           acc
  #         else
  #           acc + val
  #         end
  #       end)

  #     if sum_invalid_values > 0 do
  #       discard_invalid_tickets(rules, other_nearby_tickets, collected)
  #     else
  #       discard_invalid_tickets(rules, other_nearby_tickets, [ticket | collected])
  #     end
  #   end

  #   def discard_invalid_tickets(_rules, [], collected), do: collected

  #   @doc """
  #       iex> Aoc2020.Day16.Part2.in_any_range(6,
  #       ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
  #       true

  #       iex> Aoc2020.Day16.Part2.in_any_range(55,
  #       ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
  #       false

  #       iex> Aoc2020.Day16.Part2.in_any_range(4,
  #       ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
  #       false

  #       iex> Aoc2020.Day16.Part2.in_any_range(50,
  #       ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
  #       true

  #       iex> Aoc2020.Day16.Part2.in_any_range(15,
  #       ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
  #       true

  #       iex> Aoc2020.Day16.Part2.in_any_range(12,
  #       ...> %{"class" => [[1, 3], [5, 7]], "row" => [[6, 11], [33, 44]], "seat" => [[13, 40], [45, 50]]})
  #       false
  #   """
  #   def in_any_range(val, rules) do
  #     Map.values(rules)
  #     |> Enum.map(&List.flatten/1)
  #     |> Enum.any?(fn range ->
  #       (val >= Enum.at(range, 0) && val <= Enum.at(range, 1)) ||
  #         (val >= Enum.at(range, 2) && val <= Enum.at(range, 3))
  #     end)
  #   end

  #   def scan([cur_line | more_lines], rules, my_ticket, nearby_tickets, state) do
  #     cond do
  #       cur_line == "" ->
  #         # skip
  #         scan(more_lines, rules, my_ticket, nearby_tickets, state)

  #       cur_line != "" ->
  #         cond do
  #           cur_line == "your ticket:" ->
  #             scan(more_lines, rules, my_ticket, nearby_tickets, :in_my_ticket_section)

  #           cur_line == "nearby tickets:" ->
  #             # This section is not really needed
  #             scan(more_lines, rules, my_ticket, nearby_tickets, :in_nearby_tickets_section)

  #           state == :in_rules_section ->
  #             # parse rule
  #             {rule_name, ranges} = parse_rule(cur_line)

  #             scan(more_lines, Map.put(rules, rule_name, ranges), my_ticket, nearby_tickets, state)

  #           state == :in_my_ticket_section ->
  #             # parse my ticket or skip for now
  #             scan(
  #               more_lines,
  #               rules,
  #               parse_ticket(cur_line),
  #               nearby_tickets,
  #               state
  #             )

  #           true ->
  #             # parse nearby ticket
  #             nb = parse_ticket(cur_line)

  #             scan(
  #               more_lines,
  #               rules,
  #               my_ticket,
  #               [nb | nearby_tickets],
  #               state
  #             )
  #         end
  #     end
  #   end

  #   def scan([], rules, my_ticket, nearby_tickets, _state), do: {rules, my_ticket, nearby_tickets}

  #   @doc """
  #       iex> Aoc2020.Day16.Part2.parse_ticket("7,1,14")
  #       [7, 1, 14]
  #   """
  #   def parse_ticket(t) do
  #     # |> Enum.map(&String.trim/1)
  #     String.split(t, ",")
  #     |> Enum.map(&String.to_integer/1)
  #   end

  #   @doc """
  #       iex> Aoc2020.Day16.Part2.parse_rule("bliss: 1-3 or 6-7")
  #       {"bliss", [[1, 3], [6, 7]]}
  #   """
  #   def parse_rule(r) do
  #     [name, all_ranges] = String.split(r, ":", trim: true)

  #     ranges =
  #       String.split(all_ranges, "or", trim: true)
  #       |> Enum.map(&String.trim/1)
  #       |> Enum.map(&String.split(&1, "-"))
  #       |> Enum.map(fn y -> Enum.map(y, &String.to_integer/1) end)

  #     {name, ranges}
  #   end
end
