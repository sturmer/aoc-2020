defmodule Aoc2020.Day14.Part2 do
  def solve do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day14.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  def part_one_solver(lines), do: execute(lines, nil, %{})

  @doc """
      iex> Aoc2020.Day14.Part2.execute(["mask = 000000000000000000000000000000X1001X",
      ...>    "mem[42] = 100",
      ...>    "mask = 00000000000000000000000000000000X0XX",
      ...>    "mem[26] = 1"], nil, %{})
      208
  """
  def execute([cur_line | more_lines], cur_mask, mem) do
    case decode_line(cur_line) do
      {:mask, rhs} ->
        # IO.puts("rhs: #{rhs}")
        # IO.puts("decoded mask: #{inspect(decode_mask(rhs), pretty: true)}")
        execute(more_lines, rhs, mem)

      {:mem, addr, val_base_two} ->
        # Make the address as long as the mask
        padded_addr = String.pad_leading(addr, String.length(cur_mask), "0")

        # I know, I know
        val_base_ten = String.to_integer(val_base_two, 2)

        # IO.puts("val_base_two: #{val_base_two}")
        # IO.puts("val_base_ten: #{val_base_ten}")

        # masked_addr = apply_mask(cur_mask, padded_addr)
        # IO.puts("padded_addr: #{padded_addr}")
        # IO.puts("cur_mask: #{cur_mask}")
        # IO.puts("masked_addr: #{masked_addr}")

        new_mems =
          apply_mask(cur_mask, padded_addr)
          |> generate_addresses()

        # IO.puts("Writing #{val_base_ten} to NEW mems: #{inspect(new_mems, pretty: true)}")

        # Update mem locations with val_base_two
        overwritten_mem =
          Enum.reduce(
            new_mems,
            mem,
            fn nm, acc ->
              # IO.puts("nm: #{nm}")

              # IO.puts("write [#{val_base_two}]2 / [#{val_base_ten}]|10 to: [#{nm}]|10")

              # Just overwrite the value
              Map.put(acc, nm, val_base_ten)
            end
          )

        # IO.puts("mem: #{inspect(mem, pretty: true)}")
        # IO.puts("overwritten_mem: #{inspect(overwritten_mem, pretty: true)}\n\n")

        # IO.puts("new_mems: #{inspect(new_mems, pretty: true)}")
        # IO.puts("mem after: #{inspect(mem, pretty: true)}")
        execute(more_lines, cur_mask, overwritten_mem)
    end
  end

  def execute([], _mask, mem) do
    # IO.puts("mem: #{inspect(mem, pretty: true)}")
    Map.values(mem) |> Enum.sum()
  end

  @doc """
      iex> Aoc2020.Day14.Part2.apply_mask("00X1001X", "00101010")
      "00X1101X"

      iex> Aoc2020.Day14.Part2.apply_mask("X1001X", "100110")
      "X1011X"
  """
  def apply_mask(m, v) do
    Enum.zip(String.codepoints(m), String.codepoints(v))
    |> Enum.reduce([], fn r, acc ->
      case elem(r, 0) do
        "0" -> [elem(r, 1) | acc]
        "1" -> ["1" | acc]
        "X" -> ["X" | acc]
      end
    end)
    |> Enum.reverse()
    |> Enum.join()
  end

  @doc """
      iex> Aoc2020.Day14.Part2.generate_addresses("0X1001X")
      [50, 51, 18, 19]

      iex> a = Aoc2020.Day14.Part2.generate_addresses("00000000000000000000000000000000X0XX")
      iex> Enum.count(a)
      8
      iex> a
      [2, 3, 0, 1, 10, 11, 8, 9]

      iex> b = Aoc2020.Day14.Part2.generate_addresses("0000000000000000000000X000000000X0XX")
      iex> Enum.count(b)
      16

      # iex> c = Aoc2020.Day14.Part2.generate_addresses("X00X000X0X0")
      iex> c = Aoc2020.Day14.Part2.generate_addresses("XXXX")
      iex> Enum.count(c)
      16
  """
  def generate_addresses(v) do
    String.codepoints(v)
    |> Enum.reduce([], fn pt, acc ->
      case pt do
        "1" ->
          add_to_all(acc, "1")

        "0" ->
          add_to_all(acc, "0")

        "X" ->
          add_floating(acc)
      end
    end)
    |> Enum.map(&String.to_integer(&1, 2))
  end

  @doc """
      iex> Aoc2020.Day14.Part2.add_floating(["10", "00"])
      ["000", "001", "100", "101"]

      iex> Aoc2020.Day14.Part2.add_floating(["10", "01", "00", "11"])
      ["110", "111", "000", "001", "010", "011", "100", "101"]

      iex> Aoc2020.Day14.Part2.add_floating([])
      ["1", "0"]
  """
  def add_floating(lst) do
    if length(lst) == 0 do
      ["1", "0"]
    else
      Enum.map(lst, &(&1 <> "0"))
      |> Enum.reduce([], fn str, acc ->
        [str | [String.replace(str, ~r/0$/, "1") | acc]]
      end)
    end
  end

  @doc """
      iex> Aoc2020.Day14.Part2.add_to_all([], "1")
      ["1"]

      iex> Aoc2020.Day14.Part2.add_to_all(["110", "010"], "1")
      ["1101", "0101"]
  """
  def add_to_all(strings, what) do
    if length(strings) == 0 do
      [what]
    else
      Enum.map(strings, &(&1 <> what))
    end
  end

  @doc """
      iex> Aoc2020.Day14.Part2.decode_line("mask = 1010X101010010101X00X00011XX11011111")
      {:mask, "1010X101010010101X00X00011XX11011111"}

      iex> Aoc2020.Day14.Part2.decode_line("mem[68] = 728")
      {:mem, "1000100", "1011011000"}
  """
  def decode_line(l) do
    [lhs, rhs] = String.split(l, "=", trim: true) |> Enum.map(&String.trim/1)

    if String.match?(lhs, ~r/^mask/) do
      {:mask, rhs}
    else
      address = String.replace(lhs, ~r/^mem\[(\d+)\]$/, "\\1")

      a =
        address
        |> String.to_integer()
        |> Integer.digits(2)
        |> Integer.undigits()
        |> Integer.to_string()

      v =
        rhs
        |> String.to_integer()
        |> Integer.digits(2)
        |> Integer.undigits()
        |> Integer.to_string()

      {:mem, a, v}
    end
  end
end
