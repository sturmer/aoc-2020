defmodule Aoc2020.Day08 do
  alias Aoc2020.Day08.InstructionRecord
  alias Aoc2020.Day08.InstructionRecordMaker

  @record_separator "\n"

  def solve1 do
    parse_and_solve(&Aoc2020.Day08.last_acc_before_repeat/1)
  end

  def solve2 do
    parse_and_solve(&Aoc2020.Day08.fix_program/1)
  end

  defp parse_and_solve(fun) do
    case File.read("day8.input.txt") do
      {:ok, content} ->
        String.split(content, @record_separator, trim: true) |> fun.() |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def last_acc_before_repeat(program) do
    # acc = 0
    # current = 0
    # executed_instructions = MapSet.new()
    execute_next(0, program, 0, MapSet.new())
  end

  def fix_program(program) do
    i0 = parse_instruction(Enum.at(program, 0))

    run_executions(program, [
      %InstructionRecord{decoded_instruction: i0}
    ])
  end

  def run_executions(program, [h | rest]) do
    cond do
      h.pc >= length(program) - 1 ->
        # IO.puts("Result: #{h.acc}")
        h.acc

      MapSet.member?(h.executed, h.pc) ->
        # IO.puts(
        #   "Loop detected, abort execution and fallback (on #{inspect(h.decoded_instruction)})"
        # )

        run_executions(program, rest)

      !h.changed? ->
        # We still can make changes
        case h.decoded_instruction do
          {:acc, value} ->
            run_executions(program, enqueue_instr_after_acc(program, h, rest, false, value))

          {:jmp, offset} ->
            # Add 2 alternatives to stack: nop and jmp
            # Add nop & Add the target of the jmp, too
            enqueue_instr_after_nop(program, h, rest, true)
            |> (&run_executions(program, enqueue_inst_after_jmp(program, h, &1, false, offset))).()

          {:nop, offset} ->
            # Same as jmp, but this time changed? is true in case of jmp
            # Add nop & Add the target of the jmp, too
            enqueue_instr_after_nop(program, h, rest, false)
            |> (&run_executions(program, enqueue_inst_after_jmp(program, h, &1, true, offset))).()
        end

      true ->
        # changed was already used, so we need to only go straight
        case h.decoded_instruction do
          {:acc, value} ->
            run_executions(program, enqueue_instr_after_acc(program, h, rest, true, value))

          {:jmp, offset} ->
            run_executions(program, enqueue_inst_after_jmp(program, h, rest, true, offset))

          {:nop, _offset} ->
            # Same as jmp, but this time changed? is true in case of jmp
            # Add nop
            run_executions(program, enqueue_instr_after_nop(program, h, rest, true))
        end
    end
  end

  def run_executions(_program, []), do: IO.puts("Out of execution paths!")

  def enqueue_instr_after_acc(program, record, rest, changed?, value) do
    i_after_acc = parse_instruction(Enum.at(program, record.pc + 1))

    [
      InstructionRecordMaker.make_record(
        i_after_acc,
        changed?,
        record.pc + 1,
        MapSet.put(record.executed, record.pc),
        record.acc + value
      )
      | rest
    ]
  end

  def enqueue_instr_after_nop(program, record, rest, changed?) do
    i_after_nop = parse_instruction(Enum.at(program, record.pc + 1))

    [
      %InstructionRecord{
        decoded_instruction: i_after_nop,
        changed?: changed?,
        pc: record.pc + 1,
        executed: MapSet.put(record.executed, record.pc),
        acc: record.acc
      }
      | rest
    ]
  end

  def enqueue_inst_after_jmp(program, record, rest, changed?, offset) do
    i_next = parse_instruction(Enum.at(program, record.pc + offset))

    [
      %InstructionRecord{
        decoded_instruction: i_next,
        changed?: changed?,
        pc: record.pc + offset,
        executed: MapSet.put(record.executed, record.pc),
        acc: record.acc
      }
      | rest
    ]
  end

  def execute_next(acc, program, i, executed) do
    if i < 0 || i > length(program) || MapSet.member?(executed, i) do
      acc
    else
      executed = MapSet.put(executed, i)
      instruction = Enum.at(program, i)

      case parse_instruction(instruction) do
        {:nop, _} -> execute_next(acc, program, i + 1, executed)
        {:jmp, offset} -> execute_next(acc, program, i + offset, executed)
        {:acc, val} -> execute_next(acc + val, program, i + 1, executed)
        {:error} -> IO.puts("Parsing error: #{instruction}")
      end
    end
  end

  def parse_instruction(ins) do
    cond do
      String.match?(ins, ~r/^nop [+-]\d+$/) ->
        {:nop, String.replace(ins, ~r/^nop ([+-]\d+)$/, "\\1") |> String.to_integer()}

      String.match?(ins, ~r/^jmp ([+-]\d+)$/) ->
        {:jmp, String.replace(ins, ~r/^jmp ([+-]\d+)$/, "\\1") |> String.to_integer()}

      String.match?(ins, ~r/^acc ([+-]\d+)$/) ->
        {:acc, String.replace(ins, ~r/^acc ([+-]\d+)/, "\\1") |> String.to_integer()}

      true ->
        {:error}
    end
  end
end
