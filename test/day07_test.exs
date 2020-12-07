defmodule Day07Test do
  use ExUnit.Case
  doctest Aoc2020.Day07
  import Aoc2020.Day07

  test "strip sinks" do
    sinks = " 1 posh black bag, 1 faded green bag, 4 wavy red bags."
    m = strip_sinks(sinks)
    assert Map.get(m, "posh black") == 1
    assert Map.get(m, "faded green") == 1
    assert Map.get(m, "wavy red") == 4
  end

  test "part 1" do
    input = """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """

    assert String.split(input, "\n", trim: true) |> count_paths() == 4
  end

  test "part 2 second example" do
    input = """
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    """

    assert String.split(input, "\n", trim: true) |> count_bags() == 126
  end

  test "part 2 first example" do
    input = """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """

    assert String.split(input, "\n", trim: true) |> count_bags() == 32
  end

  @tag :skip
  test "count children" do
    graph = %{
      "bright white" => %{"shiny gold" => 1},
      "dark olive" => %{"dotted black" => 4, "faded blue" => 3},
      "dark orange" => %{"bright white" => 3, "muted yellow" => 4},
      "dotted black" => nil,
      "faded blue" => nil,
      "light red" => %{"bright white" => 1, "muted yellow" => 2},
      "muted yellow" => %{"faded blue" => 9, "shiny gold" => 2},
      "shiny gold" => %{"dark olive" => 1, "vibrant plum" => 2},
      "vibrant plum" => %{"dotted black" => 6, "faded blue" => 5}
    }

    assert count_children("shiny gold", graph) == 29
  end
end
