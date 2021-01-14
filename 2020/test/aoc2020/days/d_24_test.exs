defmodule Aoc2020.Days.D_24_Test do
  use ExUnit.Case, async: true
  import Aoc2020.Days.D_24

  setup_all do
    %{
      str: """
      sesenwnenenewseeswwswswwnenewsewsw
      neeenesenwnwwswnenewnwwsewnenwseswesw
      seswneswswsenwwnwse
      nwnwneseeswswnenewneswwnewseswneseene
      swweswneswnenwsewnwneneseenw
      eesenwseswswnenwswnwnwsewwnwsene
      sewnenenenesenwsewnenwwwse
      wenwwweseeeweswwwnwwe
      wsweesenenewnwwnwsenewsenwwsesesenwne
      neeswseenwwswnwswswnw
      nenwswwsewswnenenewsenwsenwnesesenew
      enewnwewneswsewnwswenweswnenwsenwsw
      sweneswneswneneenwnewenewwneswswnese
      swwesenesewenwneswnwwneseswwne
      enesenwswwswneneswsenwnewswseenwsese
      wnwnesenesenenwwnenwsewesewsesesew
      nenewswnwewswnenesenwnesewesw
      eneswnwswnwsenenwnwnwwseeswneewsenese
      neswnwewnwnwseenwseesewsenwsweewe
      wseweeenwnesenwwwswnew
      """
    }
  end

  test "part 1", %{str: input} do
    assert {_, 10} = part_one(input)
  end

  test "part 2", %{str: input} do
    grid = input |> input_to_grid()

    assert grid |> do_n_days(0) |> Enum.count() == 10
    assert grid |> do_n_days(1) |> Enum.count() == 15
    assert grid |> do_n_days(2) |> Enum.count() == 12
    assert grid |> do_n_days(3) |> Enum.count() == 25
    assert grid |> do_n_days(4) |> Enum.count() == 14
    assert grid |> do_n_days(5) |> Enum.count() == 23
    assert grid |> do_n_days(6) |> Enum.count() == 28
    assert grid |> do_n_days(7) |> Enum.count() == 41
    assert grid |> do_n_days(8) |> Enum.count() == 37
    assert grid |> do_n_days(9) |> Enum.count() == 49

    assert grid |> do_n_days(10) |> Enum.count() == 37
    assert grid |> do_n_days(20) |> Enum.count() == 132
    assert grid |> do_n_days(30) |> Enum.count() == 259
    assert grid |> do_n_days(40) |> Enum.count() == 406
    assert grid |> do_n_days(50) |> Enum.count() == 566
    assert grid |> do_n_days(60) |> Enum.count() == 788
    assert grid |> do_n_days(70) |> Enum.count() == 1106
    assert grid |> do_n_days(80) |> Enum.count() == 1373
    assert grid |> do_n_days(90) |> Enum.count() == 1844
    assert grid |> do_n_days(100) |> Enum.count() == 2208
  end
end
