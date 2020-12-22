defmodule Aoc2020.Day13.Part2 do
  import Number.Delimit, only: [number_to_delimited: 2]

  def solve do
    parse_and_solve(&solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day13.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  def solver(lines) do
    # we don't care about the first line
    # conf = make_conf(Enum.at(lines, 1))
    # # IO.puts("conf: #{inspect(conf, pretty: true)}")

    # # 100_000_000_000_000
    # [{conf_at_zero, _}] = Enum.filter(conf, fn {_k, v} -> v == 0 end)
    # max_key = Map.keys(conf) |> Enum.max()

    # b_max = first_conf_match(conf, conf_at_zero, max_key, 0)

    # # IO.puts("max_k: #{max_k}")
    # a = lcm(conf_at_zero, b_max)

    # IO.puts("conf_at_zero: #{conf_at_zero}")
    # IO.puts("max_key: #{max_key}")
    # IO.puts("b_max: #{b_max}")
    # IO.puts("a: #{a}")

    conf = make_conf(Enum.at(lines, 1))
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

    n = div(100_000_000_000_000 - b_max, a)

    verify(a, b_max, n, conf)
  end

  def lcm(a, b) do
    Integer.floor_div(a * b, Integer.gcd(a, b))
  end

  @doc """
    Each recurrence has the form
      a * n + b
    a_max and b_max are such that the next step is maximum.
    n is the current step of the recurrence.

      iex> Aoc2020.Day13.Part2.verify(65, 25, 0, %{5 => 0, 13 => 1, 7 => 3, 3 => 4})
      935

    221 is the lcm of the first 2 (better find the max step but this is good enough)
    102 is the first time the two are in position.
      iex> Aoc2020.Day13.Part2.verify(221, 102, 0, %{19 => 3, 13 => 2, 17 => 0})
      3417
  """
  def verify(a_max, b_max, n, conf) do
    val = a_max * n + b_max

    if rem(n, 10_000_000) == 0 && n > 0,
      do: IO.puts("t: #{number_to_delimited(val, delimiter: ",")}")

    # IO.puts("Trying val: #{val}")
    # IO.puts("n: #{n}")

    if conf_match?(conf, val) do
      val
    else
      verify(a_max, b_max, n + 1, conf)
    end
  end

  @doc """
      iex> Aoc2020.Day13.Part2.first_conf_match(%{13 => 2, 17 => 0, 19 => 3}, 17, 13, 0)
      102

      iex> Aoc2020.Day13.Part2.first_conf_match(%{5 => 0, 13 => 1}, 5, 13, 0)
      25

      iex> Aoc2020.Day13.Part2.first_conf_match(%{5 => 0, 13 => 1, 7 => 3}, 5, 7, 0)
      25

      iex> Aoc2020.Day13.Part2.first_conf_match(%{5 => 0, 13 => 1, 3 => 4}, 5, 3, 0)
      5

      iex> Aoc2020.Day13.Part2.first_conf_match(%{5 => 0, 3 => 4}, 5, 3, 0)
      5

      iex> Aoc2020.Day13.Part2.first_conf_match(%{5 => 0, 3 => 1, 4 => 3}, 5, 4, 0)
      5

      iex> Aoc2020.Day13.Part2.first_conf_match(%{5 => 0, 13 => 1, 7 => 4}, 5, 7, 0)
      10
  """
  def first_conf_match(conf, a, b, n) do
    # IO.puts("n: #{n}")
    # IO.puts("a: #{a}")
    # IO.puts("b: #{b}")
    # IO.puts("conf[y]: #{conf[b]}\n\n")

    if rem(n * b - conf[b], a) == 0 do
      n * b - conf[b]
    else
      first_conf_match(conf, a, b, n + 1)
    end
  end

  @doc """
      iex> Aoc2020.Day13.Part2.make_conf("17,x,13,19")
      %{19 => 3, 13 => 2, 17 => 0}

      iex> Aoc2020.Day13.Part2.make_conf("7,13,x,x,59,x,31,19")
      %{13 => 1, 31 => 6, 19 => 7, 59 => 4, 7 => 0}
  """
  def make_conf(input) do
    {_, conf} =
      String.split(input, ",", trim: true)
      |> Enum.reduce({-1, %{}}, fn x, acc ->
        idx = elem(acc, 0)
        cnf = elem(acc, 1)

        if x == "x" do
          {idx + 1, cnf}
        else
          {idx + 1, Map.put(cnf, String.to_integer(x), idx + 1)}
        end
      end)

    # IO.puts("conf before delete: #{inspect(conf, pretty: true)}, step: #{step}")

    # {Map.delete(conf, step), step}
    conf
  end

  @doc """
      iex> Aoc2020.Day13.Part2.conf_match?([{7, 0}, {13, 1}, {59, 4}, {31, 6}, {19, 7}], 1068781)
      true

      iex> Aoc2020.Day13.Part2.conf_match?([{17, 0}, {13, 2}, {19, 3}], 3417)
      true

      iex> Aoc2020.Day13.Part2.conf_match?([{67, 0}, {7, 1}, {59, 2}, {61, 3}], 754018)
      true

      iex> Aoc2020.Day13.Part2.conf_match?([{1789,0}, {37, 1}, {47, 2}, {1889, 3}], 1_202_161_486)
      true
  """
  def conf_match?(conf, t) do
    Enum.all?(conf, &(rem(t + elem(&1, 1), elem(&1, 0)) == 0))
  end
end
