defmodule Aoc2020.Day04 do
  def solve1 do
    parse_and_solve(&Aoc2020.Day04.count_passports/2)
  end

  def solve2 do
    parse_and_solve(&Aoc2020.Day04.count_passports_strict/2)
  end

  defp parse_and_solve(fun) do
    case File.read("day4.input.txt") do
      {:ok, content} ->
        String.split(content, "\n\n", trim: true) |> fun.(0) |> IO.puts()

      {:error, _} ->
        IO.puts("Error reading file")
    end
  end

  def count_passports([first_record | rest], cnt) do
    bag =
      String.split(first_record, ["\n", " "], trim: true)
      |> Enum.reduce(%{}, fn kv, acc ->
        [k, v] = String.split(kv, ":")
        Map.put(acc, k, v)
      end)

    if has_all_fields(bag) do
      count_passports(rest, cnt + 1)
    else
      count_passports(rest, cnt)
    end
  end

  def count_passports([], cnt) do
    cnt
  end

  def has_all_fields(bag) do
    Enum.all?(
      ~w(byr iyr eyr hgt hcl ecl pid),
      fn x -> Map.has_key?(bag, x) end
    )
  end

  def count_passports_strict([first_record | rest], cnt) do
    bag =
      String.split(first_record, ["\n", " "], trim: true)
      |> Enum.reduce(%{}, fn kv, acc ->
        [k, v] = String.split(kv, ":")
        Map.put(acc, k, v)
      end)

    if has_all_fields(bag) && are_all_fields_valid(bag) do
      count_passports_strict(rest, cnt + 1)
    else
      count_passports_strict(rest, cnt)
    end
  end

  def count_passports_strict([], cnt) do
    cnt
  end

  def are_all_fields_valid(bag) do
    Enum.all?(
      ~w(byr iyr eyr hgt hcl ecl pid),
      fn x ->
        # IO.puts("x is #{x}, bag(x): #{Map.get(bag, x)}")

        case x do
          "byr" ->
            Map.get(bag, x)
            |> check_year(1920, 2002)

          "iyr" ->
            Map.get(bag, x)
            |> check_year(2010, 2020)

          "eyr" ->
            Map.get(bag, x)
            |> check_year(2020, 2030)

          "hgt" ->
            # IO.puts("hgt")

            Map.get(bag, x)
            |> check_height()

          "hcl" ->
            # IO.puts("hcl")
            Map.get(bag, x) |> String.match?(~r/^#[0-9a-f]{6}$/)

          "ecl" ->
            # IO.puts("ecl")
            value = Map.get(bag, x)

            Enum.any?(
              ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
              fn x -> value == x end
            )

          "pid" ->
            Map.get(bag, x) |> String.match?(~r/^[0-9]{9}$/)

          true ->
            true
        end
      end
    )
  end

  def check_height(h) do
    # IO.puts(h)

    cond do
      String.match?(h, ~r/^\d+cm$/) ->
        value = String.replace(h, ~r/^(\d+)cm$/, "\\1") |> String.to_integer()
        value >= 150 && value <= 193

      String.match?(h, ~r/^\d+in$/) ->
        value = String.replace(h, ~r/^(\d+)in$/, "\\1") |> String.to_integer()
        value >= 59 && value <= 76

      true ->
        false
    end
  end

  def check_year(year_as_string, l, r) do
    if String.length(year_as_string) != 4 do
      IO.puts(
        "length is wrong: #{String.length(year_as_string)}, year_as_string: #{year_as_string}"
      )

      false
    else
      case Integer.parse(year_as_string) do
        {year, _} ->
          year >= l && year <= r

        :error ->
          IO.puts("Parsing error")
          false
      end
    end
  end
end

Aoc2020.Day04.solve2()
