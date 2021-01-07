wires = [
  'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51'.split(','),
  'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'.split(',')
]
wires = []
File.readlines(File.dirname(__FILE__) + '/a.input').each_with_index { |line, i| wires.push(line.split(',')) }

@board = Hash.new{ |h,k| h[k] = [0,0,0] }
origin_x = origin_y = 0

@x = origin_x
@y = origin_y
@intersections = []

def draw_instruction(instruction, wire)
  len = instruction[1..-1,].to_i
  if instruction[0] == 'R'
    ((@x+1)..(@x+len)).each do |i|
      @steps += 1 
      @board[[i,@y]][0] |= wire
      st = @board[[i,@y]][wire]
      @board[[i,@y]][wire] = (st==0) ? @steps : [@board[[i,@y]][wire], @steps].min
      @intersections.push([i,@y]) if @board[[i,@y]][0] == 3
    end
    @x += len
  elsif instruction[0] == 'L'
    ((@x-len)...@x).reverse_each do |i| 
      @steps += 1 
      @board[[i,@y]][0] |= wire
      st = @board[[i,@y]][wire]
      @board[[i,@y]][wire] = (st==0) ? @steps : [@board[[i,@y]][wire], @steps].min
      @intersections.push([i,@y]) if @board[[i,@y]][0] == 3
    end
    @x -= len
  elsif instruction[0] == 'U'
    ((@y+1)..(@y+len)).each do |i| 
      @steps += 1 
      @board[[@x,i]][0] |= wire
      st = @board[[@x,i]][wire]
      @board[[@x,i]][wire] = (st==0) ? @steps : [@board[[@x,i]][wire], @steps].min
      @intersections.push([@x,i]) if @board[[@x,i]][0] == 3
    end
    @y += len
  elsif instruction[0] == 'D'
    ((@y-len)...@y).reverse_each do |i|
      @steps += 1 
      @board[[@x,i]][0] = @board[[@x,i]][0] | wire
      st = @board[[@x,i]][wire]
      @board[[@x,i]][wire] = (st==0) ? @steps : [@board[[@x,i]][wire], @steps].min
      @intersections.push([@x,i]) if @board[[@x,i]][0] == 3
    end
    @y -= len
  end
end

(0..1).each do |wire|
  @steps = 0
  wires[wire].each {|instruction| draw_instruction(instruction, wire+1)}
  @x = origin_x
  @y = origin_y
end

p @intersections
p @intersections.map {|pair| @board[pair][1] + @board[pair][2]}
p @intersections.map {|pair| @board[pair][1] + @board[pair][2]}.reject(&:zero?).min
# distances = @intersections.map {|pair| (pair[0] - origin_x).abs + (pair[1] - origin_y).abs }
# p distances
# p @intersections.map {|pair| (pair[0] - origin_x).abs + (pair[1] - origin_y).abs }[1..-1].min

def trtldraw(t, instruction)
  len = instruction[1..-1].to_i / 50.0

  if instruction[0] == 'R' # this handles the case where the wire moves to the right
    t.fd(len)
  elsif instruction[0] == 'L'
    t.rt(180); t.fd(len); t.lt(180)
  elsif instruction[0] == 'U'
    t.lt(90); t.fd(len); t.rt(90)
  elsif instruction[0] == 'D'
    t.rt(90); t.fd(len); t.lt(90)
  end
end

# require 'trtl'
# class Trtl
#   def move(new_x, new_y)
#     new_x /= 10.0
#     new_y /= 10.0
#     TkcLine.new(canvas, @x, @y, new_x, new_y, :width => @width, :fill => @color) if @drawing
#     @x, @y = new_x, new_y
#     draw
#   end
# end
# t = Trtl.new
# t.color 'blue'
# wires[0].each do |instruction|
#   trtldraw(t, instruction)
# end
# t.ensure_drawn
# t.home
# t.color 'red'
# wires[1].each do |instruction|
#   trtldraw(t, instruction)
# end
# t.ensure_drawn
# t.wait
