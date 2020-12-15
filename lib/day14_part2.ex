defmodule Aoc2020.Day14.Part2 do
  import Bitwise

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

      {:mem, addr, val} ->
        # mem is %{}
        # apply_mask(cur_mask, val)

        padded_addr = String.pad_leading(addr, String.length(cur_mask), "0")

        # I know, I know
        val_as_num = String.to_integer(val, 2)
        # TODO(gianluca): Remove when done
        # IO.puts("val: #{val}")
        # IO.puts("val_as_num: #{val_as_num}")

        new_mems =
          apply_mask(cur_mask, padded_addr)
          |> generate_addresses()

        # Update mem locations with val
        mem =
          Enum.reduce(
            new_mems,
            mem,
            fn nm, acc ->
              init = nm |> String.to_integer(2)
              Map.put(acc, init, val_as_num)
            end
          )

        # TODO(gianluca): Remove when done
        # IO.puts("mem: #{inspect(mem, pretty: true)}")

        # TODO(gianluca): Remove when done
        # IO.puts("new_mems: #{inspect(new_mems, pretty: true)}")
        # IO.puts("mem after: #{inspect(mem, pretty: true)}")
        execute(more_lines, cur_mask, mem)
    end
  end

  def execute([], _mask, mem) do
    # TODO(gianluca): Remove when done
    IO.puts("mem: #{inspect(mem, pretty: true)}")
    Map.values(mem) |> Enum.sum()
  end

  @doc """
      iex> Aoc2020.Day14.Part2.apply_mask("00X1001X", "00101010")
      "00X1101X"
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
      ["0110010", "0110011", "0010010", "0010011"]
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

    # |> Enum.map(&Enum.concat/1)
  end

  @doc """
      iex> Aoc2020.Day14.Part2.add_floating(["10", "00"])
      ["000", "001", "100", "101"]

      iex> Aoc2020.Day14.Part2.add_floating(["10", "01", "00", "11"])
      ["110", "111", "000", "001", "010", "011", "100", "101"]
  """
  def add_floating(lst) do
    Enum.map(lst, &(&1 <> "0"))
    |> Enum.reduce([], fn str, acc ->
      [str | [String.replace(str, ~r/0$/, "1") | acc]]
    end)
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
      # TODO(gianluca): Remove when done
      # IO.puts("address: #{address}")
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
