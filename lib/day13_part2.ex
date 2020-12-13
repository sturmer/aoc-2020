defmodule Aoc2020.Day13.Part2 do
  import Number.Human, only: [number_to_human: 1]

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
    conf = make_conf(Enum.at(lines, 1))
    IO.puts("conf: #{inspect(conf, pretty: true)}")

    initial_times =
      Map.keys(conf)
      |> Enum.reduce(%{}, fn k, acc ->
        Map.put(acc, k, k + Map.get(conf, k))
      end)

    # TODO(gianluca): Remove when done
    IO.puts("next_times: #{inspect(initial_times, pretty: true)}")
    verify(conf, initial_times, 0, 0)
  end

  @doc """
      iex> Aoc2020.Day13.Part2.verify(%{19 => 3, 13 => 2, 17 => 0}, %{19 => 22, 13 => 15, 17 => 17}, 15, 0)
      3417

      iex> Aoc2020.Day13.Part2.verify(%{67 => 0, 7 => 1, 59 => 2, 61 => 3},
      ...>    %{67 => 67, 7 => 8, 59 => 61, 61 => 64}, 8, 0)
      754_018
  """
  def verify(conf, next_times, t, cnt) do
    if conf_match?(conf, t) do
      t
    else
      y = update_times(next_times, t)

      # IO.puts("y: #{inspect(y, pretty: true)}")

      t_next = Map.values(y) |> Enum.min()
      if rem(cnt, 100_000_000) == 0, do: IO.puts("t: #{t}, t_next: #{t_next}")

      verify(conf, y, t_next, cnt + 1)
    end
  end

  @doc """
      iex> Aoc2020.Day13.Part2.update_times(%{17 => 17, 13 => 15, 19 => 22}, 15)
      %{17 => 17, 13 => 28, 19 => 22}

      iex> Aoc2020.Day13.Part2.update_times(%{17 => 17, 13 => 28, 19 => 22}, 17)
      %{17 => 34, 13 => 28, 19 => 22}
  """
  def update_times(cur_times, t) do
    Map.keys(cur_times)
    |> Enum.reduce(%{}, fn key, acc ->
      if Map.get(cur_times, key) == t do
        Map.put(acc, key, key + Map.get(cur_times, key))
      else
        Map.put(acc, key, Map.get(cur_times, key))
      end
    end)
  end

  # @doc """
  # Initial cur_times should be conf (key + value) for every key-value.
  #     iex> Aoc2020.Day13.Part2.get_next_times(%{19 => 22, 13 => 15, 17 => 17}, 15)
  #     17

  #     iex> Aoc2020.Day13.Part2.get_next_times(%{19 => 22, 13 => 28, 17 => 17}, 15)
  #     17
  # """
  def get_next_times(cur_times, cur_t) do
    # IO.puts("cur_times: #{inspect(cur_times, pretty: true)}")
    # IO.puts("cur_t: #{cur_t}")

    x =
      Map.keys(cur_times)
      |> Enum.reduce(%{}, fn id, acc ->
        t_i = Map.get(cur_times, id)

        if t_i <= cur_t do
          Map.put(acc, id, t_i + id)
        else
          Map.put(acc, id, t_i)
        end
      end)

    # IO.puts("conf: #{inspect(cur_times, pretty: true)} x: #{inspect(x, pretty: true)}")
    Map.values(x) |> Enum.min()
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
