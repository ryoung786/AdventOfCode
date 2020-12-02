defmodule AocWeb.DayLive do
  use AocWeb, :live_view

  @impl true
  def mount(%{"day" => "1"}, _session, socket) do
    {{p1, a, b}, {p2, x, y, z}} = Aoc.Days.One.process()

    {:ok,
     assign(socket, day: 1, part_one: "#{p1} {#{a}, #{b}}", part_two: "#{p2} {#{x}, #{y}, #{z}}")}
  end

  @impl true
  def mount(%{"day" => "2"}, _session, socket) do
    {num_valid_passwords_a, num_valid_passwords_b} = Aoc.Days.Two.process()

    {:ok,
     assign(socket,
       day: 2,
       part_one: "Num valid passwords: #{num_valid_passwords_a}",
       part_two: "Num valid passwords: #{num_valid_passwords_b}"
     )}
  end
end
