defmodule Aoc2020.Day03 do
  @tree "#"
  # @empty "."

  def solve1 do
    case File.read("day3.input.txt") do
      {:ok, content} ->
        String.split(content, "\n") |> count_trees() |> IO.puts()

      # do something

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def solve2 do
    case File.read("day3.input.txt") do
      {:ok, content} ->
        String.split(content, "\n") |> count_trees_all() |> IO.puts()

      # do something

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def count_trees(lines) do
    count_and_jump(lines, 0, 0, 0)
  end

  def count_trees_all(lines) do
    a = count_and_jump_multi(lines, 0, 0, [1, 1], 0)
    b = count_and_jump_multi(lines, 0, 0, [3, 1], 0)
    c = count_and_jump_multi(lines, 0, 0, [5, 1], 0)
    d = count_and_jump_multi(lines, 0, 0, [7, 1], 0)
    e = count_and_jump_multi(lines, 0, 0, [1, 2], 0)
    a * b * c * d * e
  end

  def count_and_jump(lines, row, col, tree_count) do
    # # TODO(gianluca): Remove when done
    # IO.puts(
    #   "------------@@@> #{__MODULE__}" <>
    #     ".#{Kernel.elem(__ENV__.function, 0)}:#{__ENV__.line}" <>
    #     " - row: #{inspect(row, pretty: true)}" <>
    #     " - col: #{inspect(col, pretty: true)}" <>
    #     " - tree_count: #{inspect(tree_count, pretty: true)}"
    # )

    line = Enum.at(lines, row)

    if row >= length(lines) || String.length(line) == 0 do
      # we're past the end
      tree_count
    else
      symbol = String.slice(line, col..col)
      next_col = rem(col + 3, String.length(line))
      next_row = row + 1

      # # TODO(gianluca): Remove when done
      # IO.puts(
      #   "------------@@@> #{__MODULE__}" <>
      #     ".#{Kernel.elem(__ENV__.function, 0)}:#{__ENV__.line}" <>
      #     " - symbol: #{inspect(symbol, pretty: true)}" <>
      #     " - next_col: #{inspect(next_col, pretty: true)}" <>
      #     " - next_row: #{inspect(next_row, pretty: true)}"
      # )

      if symbol == @tree do
        count_and_jump(lines, next_row, next_col, tree_count + 1)
      else
        count_and_jump(lines, next_row, next_col, tree_count)
      end
    end
  end

  def count_and_jump_multi(lines, row, col, slope, tree_count) do
    line = Enum.at(lines, row)

    # # TODO(gianluca): Remove when done
    # IO.puts(
    #   "------------@@@> #{__MODULE__}" <>
    #     ".#{Kernel.elem(__ENV__.function, 0)}:#{__ENV__.line}" <>
    #     " - len(lines): #{inspect(length(lines), pretty: true)}" <>
    #     " - len(line): #{inspect(String.length(line), pretty: true)}" <>
    #     " - row: #{inspect(row, pretty: true)}" <>
    #     " - col: #{inspect(col, pretty: true)}" <>
    #     " - tree_count: #{inspect(tree_count, pretty: true)}"
    # )

    [x, y] = slope

    if row >= length(lines) || String.length(line) == 0 do
      # we're past the end
      tree_count
    else
      symbol = String.slice(line, col..col)
      next_row = row + y
      next_col = rem(col + x, String.length(line))

      # # TODO(gianluca): Remove when done
      # IO.puts(
      #   "------------@@@> #{__MODULE__}" <>
      #     ".#{Kernel.elem(__ENV__.function, 0)}:#{__ENV__.line}" <>
      #     " - symbol: #{inspect(symbol, pretty: true)}" <>
      #     " - next_col: #{inspect(next_col, pretty: true)}" <>
      #     " - next_row: #{inspect(next_row, pretty: true)}"
      # )

      if symbol == @tree do
        count_and_jump_multi(lines, next_row, next_col, slope, tree_count + 1)
      else
        count_and_jump_multi(lines, next_row, next_col, slope, tree_count)
      end
    end
  end
end

Aoc2020.Day03.solve2()
