defmodule Days.D_03_Test do
  use ExUnit.Case
  import Days.D_03

  setup_all do
    %{
      a: {"R8,U5,L5,D3", "U7,R6,D4,L4"},
      b: {"R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"},
      c: {"R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"}
    }
  end

  test "a", %{a: {a1, a2}, b: {b1, b2}, c: {c1, c2}} do
    assert part_one(a1 <> "\n" <> a2) == 6
    assert part_one(b1 <> "\n" <> b2) == 159
    assert part_one(c1 <> "\n" <> c2) == 135
  end

  test "b", %{a: {a1, a2}, b: {b1, b2}, c: {c1, c2}} do
    assert part_two(a1 <> "\n" <> a2) == 30
    assert part_two(b1 <> "\n" <> b2) == 610
    assert part_two(c1 <> "\n" <> c2) == 410
  end
end
