lines = [
    '.#..#',
    '.....',
    '#####',
    '....#',
    '...##'
]
lines = [
    '.#..##.###...#######',
    '##.############..##.',
    '.#.######.########.#',
    '.###.#######.####.#.',
    '#####.##.#.##.###.##',
    '..#####..#.#########',
    '####################',
    '#.####....###.#.#.##',
    '##.#################',
    '#####.##.###..####..',
    '..######..##.#######',
    '####.##.####...##..#',
    '.#####..#.######.###',
    '##...#.##########...',
    '#.##########.#######',
    '.####.#.###.###.#.##',
    '....##.##.###..#####',
    '.#.#.###########.###',
    '#.#.#.#####.####.###',
    '###.##.####.##.#..##',
]
lines = File.readlines(File.dirname(__FILE__) + '/input').map(&:strip)
@map_width = lines[0].length
@map_height = lines.length
@m1 = lines.map(&:chars)
@m2 = @m1.map{|row| row.map{|n| n == '#' ? 1 : 0}}.transpose

asteroid_locations = []
lines.each_with_index do |line, y|
  (0...line.length).select{|i| line[i]=='#'}.each do |x|
    asteroid_locations << [x,y]
  end
end

p asteroid_locations

dys = (-@map_height+1 ... @map_height).to_a
dxs = (-@map_width+1 ... @map_width).to_a
dydx_pairs = dys.product(dxs).map do |p|
    dy,dx = p
    next [0,0] if dx.zero? && dy.zero?
    next [dx/dx.abs,0] if dy.zero?
    next [0,dy/dy.abs] if dx.zero?
    foo = dy.gcd(dx)
    [dy/foo, dx/foo]
end
dydx_pairs = dydx_pairs.uniq!.reject{|p| p[0]==0 && p[1]==0}

def asteroid_in_line?(a, slope)
    return false if slope == 0
    x,y = a
    dy,dx = slope
    loop do
        x += dx
        y -= dy
        return false unless (0...@map_width).include?(x) && (0...@map_height).include?(y)
        return true if @m2[x][y] == 1
    end
    return false
end

# sight = asteroid_locations.map do |a|
#     foo = dydx_pairs.map{|slope| asteroid_in_line?(a, slope) ? 1 : 0}
#     foo.reduce(0){|sum,x| sum + x }
# end

foo = asteroid_locations.map do |a|
    slopes = []
    asteroid_locations.each do |b|
        next if a==b
        dy = b[1]-a[1]
        dx = b[0]-a[0]
            
        if dy == 0
            slopes << [dx/dx.abs, 0]
        elsif dx == 0
            slopes << [0, dy/dy.abs]
        else
            foo = dy.gcd(dx)
            slopes << [dy/foo, dx/foo]
        end
    end
    slopes.uniq.length
end
p foo.max