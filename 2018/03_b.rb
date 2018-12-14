input = File.readlines('03_input') # #1293 @ 168,680: 22x12

def parse_input(str)
  id, x, y, w, h = str.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/)
                      .captures.map(&:to_i)
  { id: id, x1: x, y1: y, x2: x+w-1, y2: y+h-1 }
end

def overlaps?(a, b)
  return !(a[:x1] > b[:x2] || a[:x2] < b[:x1] ||
           a[:y1] > b[:y2] || a[:y2] < b[:y1])
end

rects = input.map { |line| parse_input line }
rects.each do |a|
  overlaps = false
  rects.each do |b|
    if overlaps?(a, b) && (a != b)
      overlaps = true
      break
    end
  end
  if !overlaps
    puts a[:id]
    break
  end
end
