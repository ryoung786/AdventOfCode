require_relative '../Intcode'

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
(0..100).each do |y|
    (0..100).each {|x| @map[y][x]='.'}
end
@x,@y = [50,50]
@map[@y][@x] = 'R'

def move_till_wall(i)
    hit_wall = false
    while !hit_wall do
        hit_wall = move(i)
    end
end

def moveback(i, x, y)
    i=1 if i==2
    i=2 if i==1
    i=3 if i==4
    i=4 if i==3
    while @x!=x && @y!=y do
        move(i)
    end
end

def move(i)
    @input << i
    sleep(0.0001) while @output.empty?
    response = @output.shift
    # puts response
    if response == 0 # wall
        @map[@y-1][@x] = '#' if i==1
        @map[@y+1][@x] = '#' if i==2
        @map[@y][@x-1] = '#' if i==3
        @map[@y][@x+1] = '#' if i==4
    else
        # robot moved, update coordinates
        @map[@y][@x] = ' '
        @y-=1 if i == 1
        @y+=1 if i == 2
        @x-=1 if i == 3
        @x+=1 if i == 4
    end
    @map[@y][@x] = 'R' if response == 1
    @map[@y][@x] = 'X' if response == 2
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

while true do
    # @map[50][50] = 'O' if @map[50][50] == ' '
    @map[50][50] = 'O' if @map[50][50] == ' '
    display(@map)
    # i = gets.chomp.downcase while !(%w(a d w s).include?(i)
    i=0
    while !(%w(a d w s).include?(i)) do
        i = gets.chomp.downcase
    end

    i = %w(w s a d).index(i) + 1 # i is now 1,2,3,4

    # o = [@x,@y]
    # move_till_wall(i)
    # moveback(i, @x, @y)
    # explore() if !move(i)
    move(i)
    explore()

end