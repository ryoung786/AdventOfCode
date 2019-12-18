class Moon
    attr_accessor :pos, :vel
    def initialize(arr)
        @pos = arr[0,3]
        @vel = arr[3,3]
    end

    def kinetic_energy
        @vel.reduce(0) {|sum, n| sum += n.abs}
    end

    def potential_energy
        @pos.reduce(0) {|sum, n| sum += n.abs}
    end

    def total_energy
        kinetic_energy * potential_energy
    end
end

input = %q(<x=-15, y=1, z=4>
    <x=1, y=-10, z=-8>
    <x=-5, y=4, z=9>
    <x=4, y=6, z=-2>)

# input = %q(<x=-1, y=0, z=2>
#     <x=2, y=-10, z=-7>
#     <x=4, y=-8, z=8>
#     <x=3, y=5, z=-1>)
# input = %q(<x=-8, y=-10, z=0>
#     <x=5, y=5, z=10>
#     <x=2, y=-7, z=3>
#     <x=9, y=-8, z=-3>)
moons = input.split("\n").map do |line|
    x,y,z = /x=(-?\d+), y=(-?\d+), z=(-?\d+)/.match(line.strip)[1..-1].map(&:to_i)
    Moon.new([x,y,z,0,0,0])
end

p moons

# moons = [[455, -332, -167, 9, -26, 3], [-34, 51, -393, -28, 17, -5], [687, 45, -748, 6, 6, 8], [-1123, 237, 1311, 13, 3, -6]].map {|m| Moon.new(m)}
# 250k: [[-195, -16, 18, -26, 9, 25], [-440, -113, 558, 16, 14, 5], [911, 22, 619, 6, -10, -16], [-291, 108, -1192, 4, -13, -14]]
log = []
400000.times do
    log << moons.map{|m| m.pos + m.vel}
    moons.each_with_index do |m, i|
        m.vel = moons.reduce(m.vel) do |v, m2|
            v.each_with_index.map do |n,k| 
                n + (m2.pos[k] <=> m.pos[k])
            end
        end
    end
    moons.each_with_index do |m, i|
        m.pos = [0,1,2].map {|j| m.pos[j] + m.vel[j]}
    end
end

p moons.reduce(0){|a,m| a+=m.total_energy}

origin_ten = [[[-15, 1, 4, 0, 0, 0], [1, -10, -8, 0, 0, 0], [-5, 4, 9, 0, 0, 0], [4, 6, -2, 0, 0, 0]], [[-12, 2, 3, 3, 1, -1], [0, -7, -5, -1, 3, 3], [-4, 3, 6, 1, -1, -3], [1, 3, -1, -3, -3, 1]], [[-6, 4, 1, 6, 2, -2], [-2, -1, 1, -2, 6, 6], [-2, 0, 0, 2, -3, -6], [-5, -2, 1, -6, -5, 2]], [[3, 3, -2, 9, -1, -3], [-6, 6, 6, -4, 7, 5], [-2, -4, -3, 0, -4, -3], [-10, -4, 2, -5, -2, 1]], [[9, 1, -4, 6, -2, -2], [-9, 10, 8, -3, 4, 2], [-3, -6, -3, -1, -2, 0], [-12, -4, 2, -2, 0, 0]], [[12, -2, -3, 3, -3, 1], [-11, 11, 7, -2, 1, -1], [-5, -5, -2, -2, 1, 1], [-11, -3, 1, 1, 1, -1]], [[12, -6, 1, 0, -4, 4], [-11, 9, 3, 0, -2, -4], [-8, -1, 0, -3, 4, 2], [-8, -1, -1, 3, 2, -2]], [[9, -7, 4, -3, -1, 3], [-8, 4, -4, 3, -5, -7], [-11, 3, 3, -3, 4, 3], [-5, 1, 0, 3, 2, 1]], [[3, -5, 4, -6, 2, 0], [-4, -4, -8, 4, -8, -4], [-11, 6, 5, 0, 3, 2], [-3, 4, 2, 2, 3, 2]], [[-6, 0, 3, -9, 5, -1], [1, -11, -9, 5, -7, -1], [-8, 6, 4, 3, 0, -1], [-2, 6, 5, 1, 2, 3]]]

moons.each_index do |m|
    log.each_with_index do |step, i|
        [0,1,2].each do |j|
            p "Moon #{m} coord #{j} repeats at i=#{i}" if origin_ten.map{|h| h[m][j]} == log[i,10].map{|h| h[m][j]}
        end
    end
end
# Moon 0 coord 0 repeats at i=286332
# Moon 0 coord 1 repeats at i=48118
# Moon 0 coord 2 repeats at i=193052

frequencies = [
    [286332, 48118, 193052],
    [286332, 96236, 193052],
    [286332, 96236, 193052],
    [286332, 48118, 193052]
]

[286332, 96236, 193052].reduce(1, &:lcm)
# => 332477126821644

