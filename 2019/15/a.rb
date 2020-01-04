require_relative '../Intcode'

DIM = 100

def display(disp)
    disp.each {|y,h| puts h.values.join('')}
end

@input = []
@output = []
file_input = File.read(File.dirname(__FILE__) + '/input')
program = file_input.split(',').map(&:to_i)
computer = Intcode.new(program, @input, @output, 1)
t = Thread.new{computer.run()}

@map = Hash.new { |h,k| h[k] = Hash.new(' ') }
(0..DIM).each do |y|
    (0..DIM).each {|x| @map[y][x]='.'}
end
@x,@y = [DIM/2,DIM/2]
@map[@y][@x] = 'R'

def move_till_wall(i)
    hit_wall = false
    while !hit_wall do
        hit_wall = move(i)
        explore()
    end
end

def move(i)
    @input << i
    sleep(0.0001) while @output.empty?
    response = @output.shift
    if response == 0 # wall
        @map[@y-1][@x] = '#' if i==1
        @map[@y+1][@x] = '#' if i==2
        @map[@y][@x-1] = '#' if i==3
        @map[@y][@x+1] = '#' if i==4
    else
        # robot moved, update coordinates
        @map[@y][@x] = ' ' if !%w(X O).include?(@map[@y][@x])
        @y-=1 if i == 1
        @y+=1 if i == 2
        @x-=1 if i == 3
        @x+=1 if i == 4
    end
    @map[@y][@x] = 'R' if response == 1
    @map[@y][@x] = 'X' if response == 2

    100.times{puts '*******OVER OVER OVER*******'} if response == 2

    return response == 0
end

def explore()
    ox, oy = [@x, @y]
    move(1) # move north and back
    move(2) if [ox,oy] != [@x,@y]
    move(2) # move south and back
    move(1) if [ox,oy] != [@x,@y]
    move(3) # move west and back
    move(4) if [ox,oy] != [@x,@y]
    move(4) # move east and back
    move(3) if [ox,oy] != [@x,@y]
end    

def invert(i)
    case i
    when 1
        2
    when 2
        1
    when 3
        4
    when 4
        3
    end
end

def countwalls()
    walls = 0
    walls+=1 if @map[@y-1][@x] == '#'
    walls+=1 if @map[@y+1][@x] == '#'
    walls+=1 if @map[@y][@x-1] == '#'
    walls+=1 if @map[@y][@x+1] == '#'
    return walls
end

def opendirections()
    d = []
    d<<1 if @map[@y-1][@x] != '#'
    d<<2 if @map[@y+1][@x] != '#'
    d<<3 if @map[@y][@x-1] != '#'
    d<<4 if @map[@y][@x+1] != '#'
    return d
end

PART_ONE = false

while true && PART_ONE do
    @map[DIM/2][DIM/2] = 'O' if @map[DIM/2][DIM/2] == ' '
    display(@map)
    i=0
    while !(%w(a d w s j k l i x).include?(i)) do
        i = gets.chomp.downcase
    end

    ox, oy = [@x, @y]
    if  %w(w s a d).include?(i)
        # auto
        i = %w(w s a d).index(i) + 1 # i is now 1,2,3,4
        # move_till_wall(i)
        move(i)
        explore()

        # now let's count the walls around us.
        # if 2, just keep going
        # otherwise, display and kick back to user for input
        while countwalls() == 2
            i = opendirections().reject{|d| d==invert(i)}.first
            # move_till_wall(i)
            move(i)
            explore()
        end
    elsif %w(i k j l).include?(i)
        # manual
        i = %w(i k j l).index(i) + 1 # i is now 1,2,3,4
        move(i)
        explore()
    else
        puts "Wall count: #{countwalls()}"
    end
end

