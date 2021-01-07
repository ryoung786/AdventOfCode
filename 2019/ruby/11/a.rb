require_relative '../Intcode'
require 'set'



class Robot
  attr_accessor :heading, :x, :y, :hull, :input, :output, :panels_painted
  def initialize(hull)
    @hull = hull
    @heading = :up
    @x, @y = [0,0]

    # @input = [@hull[@x][@y] == :black ? 0 : 1]
    @input = [1]
    @output = []
    @panels_painted = Set[]
    @computer = init_computer()
  end

  def init_computer()
    input = File.read(File.dirname(__FILE__) + '/input')
    program = input.split(',').map(&:to_i)
    Intcode.new(program, @input, @output, 1)
  end

  def run()
    t = Thread.new{@computer.run()}
    sleep(0.001)

    ticks = 0
    while @computer.is_running
      if @output.length == 2
        ticks += 1
        color = (@output.shift == 0) ? :black : :white
        turn = (@output.shift == 0) ? :left : :right
        res = command(color, turn)
        display() if ticks % 1000 == 0
        @input << res
      else
        sleep(0.0001) # need to sleep so this main thread doesn't thrash the intcode thread
      end
    end
  end

  def command(paint_color, turn)
    dirs = {
      up: {left: :left, right: :right},
      right: {left: :up, right: :down},
      down: {left: :right, right: :left},
      left: {left: :down, right: :up},
    }
    @hull[@x][@y] = paint_color #paint
    @panels_painted.add([@x, @y])
    @heading = dirs[@heading][turn] #turn
    @x += 1 if @heading == :right # advance 1 square
    @y += 1 if @heading == :up
    @y -= 1 if @heading == :down
    @x -= 1 if @heading == :left
    return @hull[@x][@y] == :black ? 0 : 1
  end

  def display()
    (-5..0).reverse_each do |y|
      s = []
      (-5..50).each do |x|
        if x==@x && y==@y
          s << 'R'
        else
          s << (@hull[x][y] == :black ? '.' : '#')
        end
      end
      puts s.join' '
    end
    puts ' - '
  end
end

hull = Hash.new { |h,k| h[k] = Hash.new(:black) }
robot = Robot.new(hull)
robot.run()
robot.display()
p robot.panels_painted.length