defmodule Aoc.Days.D_04_Test do
  use ExUnit.Case, async: true
  import Aoc.Days.D_04

  setup_all do
    %{
      input_str: """
      ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      byr:1937 iyr:2017 cid:147 hgt:183cm

      iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      hcl:#cfa07d byr:1929

      hcl:#ae17e1 iyr:2013
      eyr:2024
      ecl:brn pid:760753108 byr:1931
      hgt:179cm

      hcl:#cfa07d eyr:2025 pid:166559648
      iyr:2011 ecl:brn hgt:59in
      """
    }
  end

  test "part a", %{input_str: input_str} do
    assert {_, 2} = part_one(input_str)
  end

  test "passport has all 8 fields" do
    str = "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\nbyr:1937 iyr:2017 cid:147 hgt:183cm"
    assert is_passport_valid(str)
  end

  test "missing 1 required field" do
    str = "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884\nhcl:#cfa07d byr:1929"
    assert not is_passport_valid(str)
  end

  test "missing just cid" do
    str = """
      hcl:#ae17e1 iyr:2013
      eyr:2024
      ecl:brn pid:760753108 byr:1931
      hgt:179cm
    """

    assert is_passport_valid(str)
  end

  test "missing cid and byr" do
    str = "hcl:#cfa07d eyr:2025 pid:166559648\niyr:2011 ecl:brn hgt:59in"
    assert not is_passport_valid(str)
  end

  test "byr" do
    assert is_field_valid("byr:2002")
    assert not is_field_valid("byr:2003")
  end

  test "pid is exactly 9 digits long" do
    assert is_field_valid("pid:384958748")
    assert not is_field_valid("pid:3948596853")
  end

  test "hgt" do
    assert is_field_valid("hgt:60in")
    assert is_field_valid("hgt:190cm")
    assert not is_field_valid("hgt:190in")
    assert not is_field_valid("hgt:190")
    assert not is_field_valid("hgt:asdf")
  end

  test "hcl" do
    assert is_field_valid("hcl:#123abc")
    assert not is_field_valid("hcl:#123abz")
    assert not is_field_valid("hcl:123abc")
  end

  describe "part b" do
    test "valid passports" do
      str = "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f"
      assert is_passport_valid(str) and all_individual_fields_valid(str)

      str = "eyr:2029 ecl:blu cid:129 byr:1989 iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm"
      assert is_passport_valid(str) and all_individual_fields_valid(str)

      str = "hcl:#888785 hgt:164cm byr:2001 iyr:2015 cid:88 pid:545766238 ecl:hzl eyr:2022"
      assert is_passport_valid(str) and all_individual_fields_valid(str)

      str = "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"
      assert is_passport_valid(str) and all_individual_fields_valid(str)
    end

    test "invalid passports" do
      str = "eyr:1972 cid:100\nhcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926"
      assert is_passport_valid(str) or not all_individual_fields_valid(str)

      str = "iyr:2019 \nhcl:#602927 eyr:1967 hgt:170cm \necl:grn pid:012533040 byr:1946"
      assert is_passport_valid(str) or not all_individual_fields_valid(str)

      str = "hcl:dab227 iyr:2012 \necl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277"
      assert is_passport_valid(str) or not all_individual_fields_valid(str)

      str = "hgt:59cm ecl:zzz \neyr:2038 hcl:74454a iyr:2023 \npid:3556412378 byr:2007"
      assert is_passport_valid(str) or not all_individual_fields_valid(str)
    end
  end
end
