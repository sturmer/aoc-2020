defmodule Aoc2020.Day09 do
  @record_separator "\n"

  def solve1 do
    parse_and_solve(&Aoc2020.Day09.weakness/2, 25)
  end

  def solve2 do
    parse_and_solve(&Aoc2020.Day09.sumset_master/2, 69_316_178)
  end

  defp parse_and_solve(fun, arg) do
    case File.read("day9.input.txt") do
      {:ok, content} ->
        String.split(content, @record_separator, trim: true) |> fun.(arg) |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def sumset_master(nums, target) do
    ints = Enum.map(nums, &String.to_integer/1)
    sumset(target, ints, Enum.take(ints, 2), 0, 1)
  end

  def sumset(target, all_nums, cur_set, i, j) do
    range_sum = Enum.sum(cur_set)

    # TODO(gianluca): Remove when done
    # IO.puts(
    #   "cur_set: #{inspect(cur_set, pretty: true)} - range_sum: #{inspect(range_sum, pretty: true)})"
    # )

    cond do
      range_sum == target ->
        Enum.min(cur_set) + Enum.max(cur_set)

      range_sum < target ->
        sumset(
          target,
          all_nums,
          cur_set ++ [Enum.at(all_nums, j + 1)],
          i,
          j + 1
        )

      range_sum > target ->
        sumset(target, all_nums, Enum.take(cur_set, 1 - length(cur_set)), i + 1, j)
    end
  end

  def weakness(nums, preamble_length) do
    {preamble, stream} =
      nums
      |> Enum.map(&String.to_integer/1)
      |> Enum.split(preamble_length)

    # # TODO(gianluca): Remove when done
    # IO.puts("""
    # ------------@@@> #{__MODULE__} | #{Kernel.elem(__ENV__.function, 0)}:#{__ENV__.line}
    # - preamble: #{inspect(preamble, pretty: true)})
    # - stream: #{inspect(stream, pretty: true)})
    # """)

    find_vuln(MapSet.new(preamble), preamble, stream)
  end

  def find_vuln(pset, p, [hs | ts]) do
    # TODO(gianluca): Remove when done
    # IO.puts("""
    # ------------@@@> #{__MODULE__} | #{Kernel.elem(__ENV__.function, 0)}:#{__ENV__.line}
    # - window: #{inspect(p, pretty: true)}
    # - hs: #{hs}
    # - pset: #{inspect(pset, pretty: true)}
    # """)

    if sums_right(p, pset, hs) do
      # slide preamble and call with ts
      p = Enum.take(p, 1 - length(p)) ++ [hs]

      # new_set = MapSet.new(p)
      # # TODO(gianluca): Remove when done
      # IO.puts("""
      # - p: #{inspect(p, pretty: true)}
      # - new_window: #{inspect(new_set, pretty: true)}
      # """)

      find_vuln(MapSet.new(p), p, ts)
    else
      hs
    end
  end

  def find_vuln(_pset, _p, []) do
    IO.puts("not found")
    -1
  end

  def sums_right([h | pool], pool_set, n) do
    # IO.puts("find n: #{n} - using h: #{h} - n-h: #{n - h}")

    # n = h + <..> => <..> = n - h
    if n - h != h && MapSet.member?(pool_set, n - h) do
      # IO.puts("#{n} = #{h} + #{n - h}")
      true
    else
      sums_right(pool, pool_set, n)
    end
  end

  def sums_right([], _pset, _n), do: false
end
