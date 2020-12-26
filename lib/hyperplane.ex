defmodule Aoc2020.Hyperplane do
  defstruct upper_left: {0, 0}, lower_right: {2, 2}, active: MapSet.new()
end
