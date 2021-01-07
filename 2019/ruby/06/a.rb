class Node
  attr_accessor  :name, :orbits, :direct_count, :indirect_count, :orbited_by, :line

  def initialize(name)
    @name = name
    @orbited_by = []
    @line = []
  end

  def to_s
    @name
  end

  def total_count
    @direct_count + @indirect_count
  end
end

fname = File.dirname(__FILE__) + '/input'
# File.readlines(fname).each_with_index { |line, i| wires.push(line.split(',')) }

test_map = %w{
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
}

# com-b-c-d
# test_map = %w{
# COM)B
# B)C
# C)D}

@orbit_map = {}
@orbited_by = Hash.new{[]}
IO::foreach(fname) do |line|
# test_map.each do |line|
  a,b = line.strip.split(')')
  a = @orbit_map.fetch(a, Node.new(a))
  b = @orbit_map.fetch(b, Node.new(b))
  @orbit_map[a.name] = a
  @orbit_map[b.name] = b
  b.orbits = a
  a.orbited_by << b
end

checksum = 0
queue = [@orbit_map['COM']]
while !(queue.empty?) do
  node = queue.shift
  node.direct_count = (node.orbits.nil?) ? 0 : 1
  node.indirect_count = (node.orbits.nil?) ? 0 : node.orbits.total_count
  checksum += node.total_count
  if !(node.orbits.nil?)
    node.line = node.orbits.line + [node.orbits.name]
  end
  queue += node.orbited_by
end
p checksum

you = @orbit_map['YOU']
santa = @orbit_map['SAN']
p you.line
p santa.line
total = 0
you.line.reverse.each_with_index do |name, i|
  if santa.line.include? name
    total = i + santa.line.reverse.index(name)
    break
  end
end

p total


