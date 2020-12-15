defmodule Aoc2020.Day15.Part1 do
  def solve() do
    execute("7,14,0,17,11,1,2")
  end

  @doc """
      iex> Aoc2020.Day15.Part1.execute("0,3,6")
      436
  """
  def execute(input) do
    #
    [turn, spoken_at, turn_to_spoken] = initialize(input)

    # IO.puts(
    #   "turn: #{turn}, sa: #{inspect(spoken_at, pretty: true)}, turn_to_spoken: #{
    #     inspect(turn_to_spoken, pretty: true)
    #   }"
    # )

    spoken_at_2020(turn, spoken_at, turn_to_spoken)
  end

  @doc """
      # iex> Aoc2020.Day15.Part1.initialize("0,3,6")
      # [4, %{0 => [1], 3 => [2], 6 => [3]}, %{1 => 0, 2 => 3, 3 => 6}]

      iex> Aoc2020.Day15.Part1.initialize("1,3,2")
      [4, %{1 => [1], 3 => [2], 2 => [3]}, %{1 => 1, 2 => 3, 3 => 2}]
  """
  def initialize(nums) do
    {spoken_at, turn_to_spoken, turn} =
      nums
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce({%{}, %{}, 0}, fn n, acc ->
        cnt = elem(acc, 2)

        {
          Map.put(elem(acc, 0), n, [cnt + 1]),
          Map.put(elem(acc, 1), cnt + 1, n),
          cnt + 1
        }
      end)

    [turn + 1, spoken_at, turn_to_spoken]
  end

  # turn: 4, sa: %{1 => [0], 2 => [3], 3 => [6]}, turn_to_spoken: %{1 => 0, 2 => 3, 3 => 6}
  @doc """
      iex> Aoc2020.Day15.Part1.spoken_at_2020(4, %{0 => [1], 3 => [2], 6 => [3]},
      ...>    %{1 => 0, 2 => 3, 3 => 6})
      436

      iex> Aoc2020.Day15.Part1.spoken_at_2020(4, %{1 => [1], 3 => [2], 2 => [3]},
      ...>    %{1 => 1, 2 => 3, 3 => 2})
      1

      iex> Aoc2020.Day15.Part1.spoken_at_2020(4, %{3 => [1], 1 => [2], 2 => [3]},
      ...>  %{1 => 3, 2 => 1, 3 => 2})
      1836
  """
  def spoken_at_2020(turn, last_two_turns_spoken, turn_to_spoken) do
    # last_two_turns_spoken %{n => [t0, t1]} -> "When where the last two times n was used?"
    # turn_to_spoken %{t => n} -> "Which number was used on turn t?"

    # get last number used
    last_num_used = Map.get(turn_to_spoken, turn - 1)

    if turn == 2021 do
      last_num_used
    else
      last_two_turns_num_was_used = Map.get(last_two_turns_spoken, last_num_used)

      # TODO(gianluca): Remove when done
      # TODO(gianluca): Remove when done
      # IO.puts(
      #   "turn: #{turn}, last_num_used: #{last_num_used}, last_two_turns_num_was_used: #{
      #     inspect(last_two_turns_num_was_used, pretty: true)
      #   }"
      # )

      cond do
        last_two_turns_num_was_used == nil || length(last_two_turns_num_was_used) == 1 ->
          # never used before
          # The new num is 0, which was used now and possibly once or more before
          times_zero_used = Map.get(last_two_turns_spoken, 0, [])
          last_two_times = add_to_overflow(times_zero_used, turn)

          spoken_at_2020(
            turn + 1,
            Map.put(last_two_turns_spoken, 0, last_two_times),
            Map.put(turn_to_spoken, turn, 0)
          )

        length(last_two_turns_num_was_used) == 2 ->
          [t0, t1] = last_two_turns_num_was_used
          # TODO(gianluca): Remove when done
          # IO.puts("t0: #{t0}")
          # # TODO(gianluca): Remove when done
          # IO.puts("t1: #{t1}")
          # # used before at least once

          # if used twice -> overflow
          # Last two turns the number was spoken was
          num_to_speak = t1 - t0
          times_t0_used = Map.get(last_two_turns_spoken, num_to_speak, [])
          # same as times_t1_used!
          overflow_list = add_to_overflow(times_t0_used, turn)

          spoken_at_2020(
            turn + 1,
            Map.put(last_two_turns_spoken, num_to_speak, overflow_list),
            Map.put(turn_to_spoken, turn, num_to_speak)
          )

        true ->
          exit(:shutdown)
      end
    end
  end

  @doc """
      iex> Aoc2020.Day15.Part1.add_to_overflow([1], 3)
      [1, 3]

      iex> Aoc2020.Day15.Part1.add_to_overflow([], 3)
      [3]

      iex> Aoc2020.Day15.Part1.add_to_overflow([1, 2], 3)
      [2, 3]
  """
  def add_to_overflow([_t0, t1], el) do
    [t1, el]
  end

  def add_to_overflow([t0], el) do
    [t0, el]
  end

  def add_to_overflow([], el) do
    [el]
  end
end
