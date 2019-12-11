lines = File.readlines(File.dirname(__FILE__) + '/input')
lines = [
    '.#..#',
    '.....',
    '#####',
    '....#',
    '...##'
]
m = lines.map(&:chars)

asteroid_locations = []
lines.each_with_index do |line, y|
  (0...line.length).select{|i| line[i]=='#'}.each do |x|
    asteroid_locations << [x,y]
  end
end

p asteroid_locations

def can_see(a,b)
    # can we see b from a
    ax,ay = a
    bx,by = b

    mx = bx - ax
    my = by - ay
end

count = []

asteroid_locations.each do |a|
    sum = 0
    asteroid_locations.each do |b|
        next if a == b
        sum += 1 if can_see(a,b)
    end
    count << sum
end

p count
p count.max