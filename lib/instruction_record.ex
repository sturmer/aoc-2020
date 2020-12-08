defmodule Aoc2020.Day08.InstructionRecord do
  defstruct [:decoded_instruction, changed?: false, pc: 0, executed: MapSet.new(), acc: 0]
end
