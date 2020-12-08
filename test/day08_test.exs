defmodule Day08Test do
  use ExUnit.Case
  doctest Aoc2020.Day08
  import Aoc2020.Day08

  test "parse instructions" do
    assert parse_instruction("nop +56") == {:nop, 56}
    assert parse_instruction("jmp -81") == {:jmp, -81}
    assert parse_instruction("acc -9") == {:acc, -9}
  end

  test "part 1" do
    assert last_acc_before_repeat(
             String.split(
               """
               nop +0
               acc +1
               jmp +4
               acc +3
               jmp -3
               acc -99
               acc +1
               jmp -4
               acc +6
               """,
               "\n"
             )
           ) == 5
  end

  test "part 2" do
    res =
      case File.read("day8.input.txt") do
        {:ok, content} ->
          String.split(content, "\n", trim: true) |> fix_program()

        {:error, _} ->
          IO.puts("Error reading file")
      end

    assert res == 515
  end

  test "part 2, change nop" do
    #  acc +1
    #  -> nop +3
    #  jmp -2
    #  jmp -3
    #  acc +2
    # needs to change the nop to jmp to terminate
    assert fix_program(
             String.split(
               """
               acc +1
               nop +3
               jmp -2
               jmp -3
               acc +2
               """,
               "\n"
             )
           ) == 3
  end

  test "part 2, change jmp" do
    #  nop +0
    #  acc +1
    #  jmp +4
    #  acc +3
    #  jmp -3
    #  acc -99
    #  acc +1
    #  jmp -4
    #  acc +6
    # needs to change last jmp to nop
    assert fix_program(
             String.split(
               """
               nop +0
               acc +1
               jmp +4
               acc +3
               jmp -3
               acc -99
               acc +1
               jmp -4
               acc +6
               """,
               "\n"
             )
           ) == 8
  end
end
