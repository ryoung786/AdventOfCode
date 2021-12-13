defmodule Aoc.Year2020.Day21 do
  use Aoc.DayBase

  def parse_input(str) do
    lines = String.split(str, "\n", trim: true)
    words = String.split(str, ~r/[\s\(\)]/, trim: true)

    foods =
      Enum.map(lines, fn line ->
        line
        |> String.split(~r/\(contains|\)/, trim: true)
        |> Enum.map(&String.split(&1, ~r/\s+|,/, trim: true))
      end)

    {Enum.frequencies(words), foods}
  end

  @impl true
  def part_one(str) do
    {freq, foods} = parse_input(str)

    foods
    |> possible_allergens()
    |> get_safe_ingredients(foods)
    |> Enum.map(fn ingredient -> freq[ingredient] end)
    |> Enum.sum()
  end

  @impl true
  def part_two(str) do
    {_, foods} = parse_input(str)
    known = foods |> possible_allergens() |> known_allergens()
    known |> ingredients_sorted_by_allergen() |> Enum.join(",")
  end

  def ingredients_sorted_by_allergen(known),
    do: known |> Map.keys() |> Enum.sort() |> Enum.map(fn key -> known[key] end)

  def possible_allergens(foods) do
    foods
    |> Enum.reduce(%{}, fn [ingredients, allergens], m ->
      Enum.reduce(allergens, m, fn allergen, m ->
        Map.update(m, allergen, MapSet.new(ingredients), fn set ->
          MapSet.intersection(set, MapSet.new(ingredients))
        end)
      end)
    end)
  end

  def get_safe_ingredients(possible_allergens_map, foods) do
    all_ingredients = foods |> Enum.flat_map(&hd/1) |> MapSet.new()
    all_possible_allergens = Map.values(possible_allergens_map) |> Enum.reduce(&MapSet.union/2)
    all_ingredients |> Enum.reject(fn ingredient -> ingredient in all_possible_allergens end)
  end

  def known_allergens(possible, known \\ %{})
  def known_allergens(possible, known) when possible == %{}, do: known

  def known_allergens(possible, known) do
    {allergen, ingredient_set} = Enum.find(possible, fn {_, v} -> Enum.count(v) == 1 end)
    known = Map.put(known, allergen, MapSet.to_list(ingredient_set) |> hd())

    possible =
      possible
      |> Enum.map(fn {k, v} -> {k, MapSet.difference(v, ingredient_set)} end)
      |> Enum.into(%{})
      |> Map.delete(allergen)

    known_allergens(possible, known)
  end
end
