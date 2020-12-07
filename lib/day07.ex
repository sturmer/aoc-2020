defmodule Aoc2020.Day07 do
  def solve1 do
    parse_and_solve(&Aoc2020.Day07.count_paths/1)
  end

  def solve2 do
    parse_and_solve(&Aoc2020.Day07.count_bags/1)
  end

  defp parse_and_solve(fun) do
    case File.read("day7.input.txt") do
      {:ok, content} ->
        String.split(content, "\n", trim: true) |> fun.() |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def count_bags(rules) do
    graph = build_map(rules)
    count_children("shiny gold", graph)
  end

  def count_children(src, gr) do
    children = Map.get(gr, src)

    if children == nil do
      0
    else
      Enum.reduce(Map.keys(children), 0, fn child, acc ->
        multiplier = Map.get(children, child)

        # need to count the containing bags too!
        acc + multiplier * count_children(child, gr) + multiplier
      end)
    end
  end

  def count_paths(rules) do
    graph = build_map(rules)

    Enum.reduce(Map.keys(graph), 0, fn src, acc ->
      if can_reach(src, "shiny gold", graph) do
        acc + 1
      else
        acc
      end
    end)
  end

  def can_reach(src, dest, gr) do
    children = Map.get(gr, src)

    if children == nil do
      false
    else
      if Map.has_key?(children, dest) do
        true
      else
        Enum.any?(Map.keys(children), fn child -> can_reach(child, dest, gr) end)
      end
    end
  end

  def build_map(rules) do
    Enum.reduce(rules, %{}, fn rule, acc ->
      [source, sinks] = String.split(rule, "contain", trim: true)
      stripped_source = strip_source(source)
      stripped_sinks = strip_sinks(sinks)

      Map.put(acc, stripped_source, stripped_sinks)
    end)
  end

  def strip_source(s) do
    # "wavy green bags "
    String.split(s, "bag", parts: 2) |> Enum.at(0) |> String.trim()
  end

  def strip_sinks(sinks) do
    # " 1 posh black bag, 1 faded green bag, 4 wavy red bags."
    String.trim(sinks)
    |> String.split(", ")
    |> Enum.map(fn s -> String.split(s, " ", parts: 2) end)
    |> Enum.reduce(%{}, fn sink, acc ->
      [num, desc] = sink

      if num != "no" do
        Map.put(acc, strip_source(desc), String.to_integer(num))
      end
    end)
  end
end
