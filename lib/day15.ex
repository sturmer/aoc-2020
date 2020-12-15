defmodule Aoc2020.Day15 do
  def solve(target \\ 2020) do
    execute("7,14,0,17,11,1,2", target)
  end

  @doc """
      iex> Aoc2020.Day15.execute("0,3,6", 2020)
      436
  """
  def execute(input, target) do
    [turn, spoken_at, turn_to_spoken] = initialize(input)
    spoken_at_target(turn, spoken_at, turn_to_spoken, target)
  end

  @doc """
      # iex> Aoc2020.Day15.initialize("0,3,6")
      # [4, %{0 => [1], 3 => [2], 6 => [3]}, %{1 => 0, 2 => 3, 3 => 6}]

      iex> Aoc2020.Day15.initialize("1,3,2")
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

  @doc """
      iex> Aoc2020.Day15.spoken_at_target(4, %{0 => [1], 3 => [2], 6 => [3]},
      ...>    %{1 => 0, 2 => 3, 3 => 6}, 2020)
      436

      iex> Aoc2020.Day15.spoken_at_target(4, %{1 => [1], 3 => [2], 2 => [3]},
      ...>    %{1 => 1, 2 => 3, 3 => 2}, 2020)
      1

      iex> Aoc2020.Day15.spoken_at_target(4, %{3 => [1], 1 => [2], 2 => [3]},
      ...>  %{1 => 3, 2 => 1, 3 => 2}, 2020)
      1836
  """
  def spoken_at_target(turn, last_two_turns_spoken, turn_to_spoken, target) do
    # last_two_turns_spoken %{n => [t0, t1]} -> "When where the last two times n was used?"
    # turn_to_spoken %{t => n} -> "Which number was used on turn t?"

    # get last number used
    last_num_used = Map.get(turn_to_spoken, turn - 1)

    if turn == target + 1 do
      last_num_used
    else
      last_two_turns_num_was_used = Map.get(last_two_turns_spoken, last_num_used)

      cond do
        last_two_turns_num_was_used == nil || length(last_two_turns_num_was_used) == 1 ->
          # never used before
          # The new num is 0, which was used now and possibly once or more before
          times_zero_used = Map.get(last_two_turns_spoken, 0, [])
          last_two_times = add_to_overflow(times_zero_used, turn)

          spoken_at_target(
            turn + 1,
            Map.put(last_two_turns_spoken, 0, last_two_times),
            Map.put(turn_to_spoken, turn, 0),
            target
          )

        length(last_two_turns_num_was_used) == 2 ->
          [t0, t1] = last_two_turns_num_was_used

          # if used twice -> overflow
          # Last two turns the number was spoken was
          num_to_speak = t1 - t0
          times_t0_used = Map.get(last_two_turns_spoken, num_to_speak, [])
          # same as times_t1_used!
          overflow_list = add_to_overflow(times_t0_used, turn)

          spoken_at_target(
            turn + 1,
            Map.put(last_two_turns_spoken, num_to_speak, overflow_list),
            Map.put(turn_to_spoken, turn, num_to_speak),
            target
          )

        true ->
          exit(:shutdown)
      end
    end
  end

  @doc """
      iex> Aoc2020.Day15.add_to_overflow([1], 3)
      [1, 3]

      iex> Aoc2020.Day15.add_to_overflow([], 3)
      [3]

      iex> Aoc2020.Day15.add_to_overflow([1, 2], 3)
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
