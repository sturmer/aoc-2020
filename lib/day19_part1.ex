defmodule Aoc2020.Day19.Part1 do
  def solve do
    # parse_and_solve(&part_one_solver/1)
  end

  # defp parse_and_solve(fun) do
  #   File.stream!("day19.input.txt")
  #   |> Enum.map(&String.trim/1)
  #   |> fun.()
  # end

  # def part_one_solver(lines) do
  #   # [rules, messages] = parse_rules(lines, %{})
  # end

  # @doc ~S"""
  #   Transforms the input into two maps of terminals and non-terminals.
  #   Terminals look like "a" or "b", non-terminals are all the rest (and
  #   need to be expanded using the terminals).

  #   Simplest input:
  #     0: 1 2
  #     1: "a"
  #     2: 1 3 | 3 1
  #     3: "b"

  #   More advanced input:
  #     0: 4 1 5
  #     1: 2 3 | 3 2
  #     2: 4 4 | 5 5
  #     3: 4 5 | 5 4
  #     4: "a"
  #     5: "b"

  #     iex> Aoc2020.Day19.Part1.parse_rule_lines(["0: 1 2", "1: \"a\"", "2: 1 3 | 3 1", "3: \"b\""])
  #     {%{"1" => "a", "3" => "b"}, %{"0" => "1 2", "2" => "1 3 | 3 1"}}
  # """
  # def parse_rule_lines(lines) do
  #   Enum.reduce(lines, {%{}, %{}}, fn line, acc ->
  #     terminals = elem(acc, 0)
  #     non_terminals = elem(acc, 1)

  #     [rule_id, rule] = String.split(line, ": ", trim: true)

  #     # IO.puts("line: #{line}")
  #     # IO.puts("rule_id: #{rule_id}")
  #     # IO.puts("rule: #{rule}\n\n")

  #     if String.starts_with?(rule, "\"") do
  #       {Map.put(terminals, rule_id, String.replace(rule, "\"", "")), non_terminals}
  #     else
  #       {terminals, Map.put(non_terminals, rule_id, rule)}
  #     end
  #   end)
  # end

  # # def parse_rules(terminals, non_terminals) do
  # #   if Enum.count(non_terminals) == 0 do
  # #     terminals
  # #   else
  # #     {id, rule} = Enum.at(non_terminals, 0)

  # #     rule
  # #     |> String.codepoints()
  # #     |> Enum.map(fn p ->
  # #       if p in Map.keys(terminals) do
  # #         # we can expand p directly
  # #         Map.get(terminals, p)
  # #       else
  # #         parse_rule(p, terminals, non_terminals)
  # #       end
  # #     end)
  # #   end
  # # end

  # # @doc """
  # #   Rules can be:
  # #     - terminals: "12: b"
  # #     - simple non-terminals: "13 78"
  # #     - alternative non-terminals: "56 21 | 5 29"

  # #     iex> Aoc2020.Day19.Part1.parse_one_rule("1 2", [], %{"1" => "a", "2" => "b"})
  # #     ["ab"]

  # #     iex> Aoc2020.Day19.Part1.parse_one_rule("1 2 | 2 1", [], %{"1" => "a", "2" => "b"})
  # #     ["ab", "ba"]

  # #     iex> Aoc2020.Day19.Part1.parse_one_rule("1 2 | 3 1", []
  # #     ...>  %{"1" => "a", "2" => "b", "3" => "1"})
  # #     ["ab", "aa"]

  # #   If the rule is "1 2|3 1" and the grammar 1: "a", 2: "b", 3: "1 | 2", then
  # #   we need these steps:
  # #   "1 2 | 3 1"
  # #   "a b | ((1 | 2) a)"
  # #   "a b | ((a | b) a)"
  # #   "ab | (aa | ba)"
  # #   "abaa|abba"

  # #     # iex> Aoc2020.Day19.Part1.parse_one_rule("1 2 | 3 1", []
  # #     # ...>  %{"1" => "a", "2" => "b", "3" => "1 | 2"})
  # #     # ["abaa", "abba"]
  # # """
  # # def parse_one_rule(r, expanded_rule, grammar) do
  # #   IO.puts("r: '#{r}'")

  # #   cond do
  # #     is_term?(r) ->
  # #       expanded_rule ++ [r]

  # #     String.contains?(r, "|") ->
  # #       # alternative non-terminals
  # #       [x, y] = String.split(r, "|", trim: true) |> Enum.map(&String.trim/1)
  # #       # must become xxxx|xxxx
  # #       expanded_rule ++
  # #         [parse_one_rule(x, grammar, expanded_rule), parse_one_rule(y, grammar, expanded_rule)]

  # #     String.contains?(r, " ") ->
  # #       [x, y] = String.split(r, " ", trim: true) |> Enum.map(&String.trim/1)
  # #       expanded_rule ++ [parse_one_rule(x, grammar) <> parse_one_rule(y, grammar)]

  # #     true ->
  # #       expanded_rule ++ [parse_one_rule(Map.get(grammar, r), grammar)]
  # #   end
  # # end

  # @doc """
  #   Smart and extensive use of parentheses.

  #     iex> Aoc2020.Day19.Part1.reduce_expression("a b")
  #     ["ab"]

  #     iex> Aoc2020.Day19.Part1.reduce_expression("a b a")
  #     ["aba"]

  #     iex> Aoc2020.Day19.Part1.reduce_expression("a | b")
  #     ["a", "b"]

  #     iex> Aoc2020.Day19.Part1.reduce_expression("a (b | a))")
  #     ["ab", "ba"]

  #     iex> Aoc2020.Day19.Part1.reduce_expression("b | ((a | b) a)")
  #     ["baa", "bba"]

  #     iex> Aoc2020.Day19.Part1.reduce_expression("a (b | ((a | b) a))")
  #     ["abaa", "abba"]
  # """
  # def reduce_expression(expr) do
  #   state = :clear
  #   open_parens = 0

  #   String.codepoints(expr)
  #   |> Enum.reduce([], fn atom, acc ->
  #     case atom do
  #       x when x != " " and x != "|" ->
  #         if Enum.count(acc) == 0 do
  #           [atom | acc]
  #         else
  #           Enum.map(acc, &(&1 <> atom))
  #         end

  #       " " ->
  #         acc

  #       "|" ->
  #         # Enum.map(acc, &(&1 <> atom))
  #         acc

  #       # generate a string with everything on the left till open
  #       # parens and everything on the right of | till closed parens

  #       "(" ->
  #         state = :open
  #         open_parens = open_parens + 1
  #         acc

  #       ")" ->
  #         acc

  #       _ ->
  #         acc
  #     end
  #   end)
  # end

  # def is_term?(rule) do
  #   rule == "a" || rule == "b"
  # end

  # @doc """
  #   Tell if a message is valid according to the expanded grammar.
  #   The grammar (rule 0) will only contain terminals.

  #   message: aab
  #   grammar: "aab | aba"
  #   -> VALID

  #     iex> Aoc2020.Day19.Part1.match?("aab", ["aab", "aba"])
  #     true

  #   message: abb
  #   grammar: "aab | aba"
  #   -> INVALID

  #     iex> Aoc2020.Day19.Part1.match?("abb", ["aab", "aba"])
  #     false
  # """
  # def match?(message, grammar) do
  #   Enum.any?(grammar, &(message == &1))
  # end
end
