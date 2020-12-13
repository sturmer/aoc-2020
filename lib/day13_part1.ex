defmodule Aoc2020.Day13.Part1 do
  def solve do
    parse_and_solve(&part_one_solver/1)
  end

  defp parse_and_solve(fun) do
    File.stream!("day13.input.txt")
    |> Enum.map(&String.trim/1)
    |> fun.()
  end

  def part_one_solver(lines) do
    {id, dep} =
      find_departure(
        String.to_integer(Enum.at(lines, 0)),
        String.split(Enum.at(lines, 1), ",", trim: true)
      )

    start = String.to_integer(Enum.at(lines, 0))
    minutes = dep - start
    minutes * id
  end

  @doc ~S"""
      iex> Aoc2020.Day13.Part1.find_departure(939, ["7","13","x","x","59","x","31","19"])
      {59, 944}
  """
  def find_departure(target, ids) do
    recs =
      Enum.filter(ids, &(&1 != "x"))
      |> Enum.reduce(%{}, fn x, acc ->
        Map.put(
          acc,
          String.to_integer(x) * (div(target, String.to_integer(x)) + 1),
          String.to_integer(x)
        )
      end)

    # %{59 => 924, 56 => 886}

    # IO.puts("recs: #{inspect(recs, pretty: true)}")

    mintime =
      Map.keys(recs)
      |> Enum.filter(&(&1 >= target))
      |> Enum.min()

    id = Map.get(recs, mintime)
    # IO.puts("id: #{id}, mintime: #{mintime}")

    {id, mintime}
  end
end
