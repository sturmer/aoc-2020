defmodule Day13Part2Test do
  use ExUnit.Case
  doctest Aoc2020.Day13.Part2
  import Aoc2020.Day13.Part2

  defp parse_example(input, expected, start_from \\ 0) do
    conf = make_conf(input)
    # IO.puts("conf: #{inspect(conf, pretty: true)}")

    next_times = first_after(start_from, conf)
    first_t = Map.values(next_times) |> Enum.min()

    assert verify(conf, next_times, first_t, 0) == expected
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

  # # @tag timeout: :infinity
  test "longest example" do
    parse_example("1789,37,47,1889", 1_202_161_486, 1_200_000_000)
  end

  # @tag :skip
  # test "part 2" do
  #   assert solve() == 4207
  # end
end
