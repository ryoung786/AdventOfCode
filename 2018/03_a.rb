input = File.readlines('03_input') # #1293 @ 168,680: 22x12
fabric = Hash.new(0)

def parse_input(str, fabric)
  id, x, y, w, h = str.match(/(#\d+) @ (\d+),(\d+): (\d+)x(\d+)$/).captures.map(&:to_i)
  for i in (x...x+w)
    for j in (y...y+h)
      fabric["#{i}, #{j}"] += 1
    end
  end
  fabric
end

input.map { |line| fabric = parse_input(line, fabric) }

puts fabric.values.select { |v| v > 1 }.count
