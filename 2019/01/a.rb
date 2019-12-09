def solve()
  sum = 0
  IO::foreach('a.input') do |line|
    sum += (line.to_i / 3) - 2
  end
  p "hello world"
  sum
end

p solve()

def b()
  all_fuel = 0
  IO::foreach('a.input') do |line|
    mass = line.to_i
    loop do
      fuel = (mass / 3) - 2
      break unless fuel > 0
      all_fuel += fuel
      mass = fuel
    end
  end
  all_fuel
end

p b()

@all_fuel = 0
mass = 14
loop do
  fuel = (mass / 3) - 2
  break unless fuel > 0
  @all_fuel += fuel
  mass = fuel
end

  p @all_fuel