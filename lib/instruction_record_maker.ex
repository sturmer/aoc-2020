defmodule Aoc2020.Day08.InstructionRecordMaker do
  alias Aoc2020.Day08.InstructionRecord

  def make_record(ins, changed?, pc, executed, acc) do
    %InstructionRecord{
      decoded_instruction: ins,
      changed?: changed?,
      pc: pc,
      executed: executed,
      acc: acc
    }
  end

  # FIXME(gianluca): OK I can't find a better way
end
