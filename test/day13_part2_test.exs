defmodule Day13Part2Test do
  use ExUnit.Case
  doctest Aoc2020.Day13.Part2
  import Aoc2020.Day13.Part2

  defp parse_example(input, expected, start_from \\ 0) do
    conf = make_conf(input)
    # IO.puts("conf: #{inspect(conf, pretty: true)}")

    # 100_000_000_000_000
    [{conf_at_zero, _}] = Enum.filter(conf, fn {_k, v} -> v == 0 end)

    max_key = Map.keys(conf) |> Enum.min()
    b_max = first_conf_match(conf, conf_at_zero, max_key, 0)

    a = lcm(conf_at_zero, max_key)

    # IO.puts("conf_at_zero: #{conf_at_zero}")
    # IO.puts("max_key: #{max_key}")
    # IO.puts("b_max: #{b_max}")
    # IO.puts("a: #{a}")

    # TODO(gianluca):
    # Checked until 119_181_009_999_971, then I got scared that my machine
    # had been pushing if for too long and stopped it.

    n = div(start_from - b_max, a)

    assert verify(a, b_max, n, conf) == expected
  end

  test "example 1" do
    parse_example("17,x,13,19", 3417, 3000)
  end

  test "example 2" do
    parse_example("7,13,x,x,59,x,31,19", 1_068_781, 1_000_000)
  end

  test "example 3" do
    parse_example("67,7,59,61", 754_018)
    parse_example("67,x,7,59,61", 779_210)
    parse_example("67,7,x,59,61", 1_261_476)
  end

  test "longest example" do
    for i <- 1_200_000_000..1_200_000_099 do
      parse_example("1789,37,47,1889", 1_202_161_486, i)
    end
  end

  @tag :skip
  test "part 2" do
    assert solve() == 4207
  end
end
