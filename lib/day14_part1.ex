defmodule Aoc2020.Day14.Part1 do
  import Bitwise

  def solve() do
    File.stream!("day14.input.txt")
    |> Enum.map(&String.trim/1)
    |> execute(%{1 => [], 0 => []}, %{})
  end

  @doc """
      iex> Aoc2020.Day14.Part1.execute(["mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X",
      ...>    "mem[8] = 11",
      ...>    "mem[7] = 101",
      ...>    "mem[8] = 0"], nil, %{})
      165
  """
  def execute([cur_line | more_lines], cur_mask, mem) do
    case decode_line(cur_line) do
      {:mask, rhs} ->
        # TODO(gianluca): Remove when done
        # IO.puts("rhs: #{rhs}")
        # IO.puts("decoded mask: #{inspect(decode_mask(rhs), pretty: true)}")
        execute(more_lines, decode_mask(rhs), mem)

      {:mem, addr, val} ->
        new_mem = apply_mask(cur_mask, val)
        execute(more_lines, cur_mask, Map.put(mem, addr, new_mem))
    end
  end

  def execute([], _mask, mem) do
    Map.values(mem) |> Enum.sum()
  end

  @doc """
      iex> Aoc2020.Day14.Part1.decode_line("mask = 1010X101010010101X00X00011XX11011111")
      {:mask, "1010X101010010101X00X00011XX11011111"}

      iex> Aoc2020.Day14.Part1.decode_line("mem[68] = 728")
      {:mem, 68, 728}
  """
  def decode_line(l) do
    [lhs, rhs] = String.split(l, "=", trim: true) |> Enum.map(&String.trim/1)

    if String.match?(lhs, ~r/^mask/) do
      {:mask, rhs}
    else
      address = String.replace(lhs, ~r/^mem\[(\d+)\]$/, "\\1")
      # TODO(gianluca): Remove when done
      # IO.puts("address: #{address}")
      {:mem, String.to_integer(address), String.to_integer(rhs)}
    end
  end

  @doc """
      iex> Aoc2020.Day14.Part1.mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 11)
      73

      iex> Aoc2020.Day14.Part1.mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 101)
      101

      iex> Aoc2020.Day14.Part1.mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 0)
      64
  """
  def mask(m, n) do
    # TODO(gianluca): unused
    dm = decode_mask(m)
    apply_mask(dm, n)
  end

  @doc """
      iex> Aoc2020.Day14.Part1.apply_mask(%{1 => [6], 0 => [1]}, 11)
      73

      iex> Aoc2020.Day14.Part1.apply_mask(%{1 => [6], 0 => [1]}, 101)
      101

      iex> Aoc2020.Day14.Part1.apply_mask(%{1 => [6], 0 => [1]}, 0)
      64

      iex> Aoc2020.Day14.Part1.apply_mask(%{1 => [5], 0 => [1, 6]}, 11)
      41
  """
  def apply_mask(dm, n) do
    apply_zeroes(n, Map.get(dm, 0)) |> apply_ones(Map.get(dm, 1))
  end

  @doc """
      iex> Aoc2020.Day14.Part1.apply_ones(9, [6])
      73
  """
  def apply_ones(n, ones) do
    Enum.reduce(ones, 0, fn d, acc ->
      acc + :math.pow(2, d)
    end)
    |> floor()
    |> bor(n)
  end

  @doc """
      iex> Aoc2020.Day14.Part1.apply_zeroes(11, [1])
      9
  """
  def apply_zeroes(n, zeroes) do
    Enum.reduce(zeroes, 0, fn d, acc ->
      acc + :math.pow(2, d)
    end)
    |> floor()
    |> bnot()
    |> band(n)
  end

  @doc """
      iex> Aoc2020.Day14.Part1.decode_mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
      %{1 => [6], 0 => [1]}

      iex> Aoc2020.Day14.Part1.decode_mask("10100X00X")
      %{1 => [8, 6], 0 => [7, 5, 4, 2, 1]}
  """
  def decode_mask(m) do
    {res, _} =
      String.codepoints(m)
      |> Enum.reverse()
      |> Enum.reduce({%{1 => [], 0 => []}, 0}, fn val, acc ->
        dm = elem(acc, 0)
        pos = elem(acc, 1)

        # TODO(gianluca): Remove when done
        # IO.puts("m: #{inspect(m, pretty: true)}")
        # IO.puts("pos: #{pos}")

        if val == "X" do
          {dm, pos + 1}
        else
          d = String.to_integer(val)
          {%{dm | d => [pos | Map.get(dm, d)]}, pos + 1}
        end
      end)

    res
  end
end
