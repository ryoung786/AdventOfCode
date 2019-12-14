lines = File.readlines(File.dirname(__FILE__) + '/input').map(&:strip)
lines = [
    '.#..#',
    '.....',
    '#####',
    '....#',
    '...##'
]
lines = [
'.#....#####...#..',
'##...##.#####..##',
'##...#...#.#####.',
'..#.....#...###..',
'..#.#.....#....##',    
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
p asteroid_locations[foo.index(foo.max)]


# begin part 2
origin = asteroid_locations[foo.index(foo.max)]

# we're gonna convert each asteroid location
# to polar coordinates, then store them in a hash
# where the key is the angle, the val is an
# array of magnitudes

h = Hash.new{[]}
asteroid_locations.each do |asteroid|
    x,y = asteroid
    a = Complex(x - origin[0], origin[1]-y)
    next if a.abs == 0
    h[a.arg] = (h[a.arg] + [a.abs]).sort # arg = theta, abs = r
end

# now we have to iterate through all our angles
# but we want to do clockwise starting from PI/2
# so let's sort and move our index i to PI/2

lasered = []
i=0
thetas = h.keys.sort
i+=1 while thetas[i]<(Math::PI/2)

# debugging stuff
out = lines
out[origin[1]][origin[0]] = 'O'

# loop through each angle, pop off the smallest magnitude
while lasered.length<299 do
    angle = thetas[i]
    if !(h[angle].empty?)
        p lasered.length+1
        x,y = Complex.polar(h[angle].shift, angle).rect.map(&:round)
        # out[origin[1]-y][x+origin[0]] = '*'
        # out.each{|line| p line}
        lasered << [x+origin[0], origin[1]-y]
    end
    i = (i-1)%thetas.length
end
p lasered.take(200).last