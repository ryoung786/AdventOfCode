require_relative '../Intcode'


def display(disp, score)
    disp.each {|y,h| puts h.values.join('').gsub('0',' ')}
    puts score
end

@input = []
@output = []
file_input = File.read(File.dirname(__FILE__) + '/input')
program = file_input.split(',').map(&:to_i)
program[0] = 2
computer = Intcode.new(program, @input, @output, 1)
t = Thread.new{computer.run()}

sleep(2)

@score = 0
@ball_x = 0
@paddle_x = 0
@disp = Hash.new { |h,k| h[k] = Hash.new(0) }
def update_game()
    processed = 0
    @output.each_slice(3) do |instruction|
        processed += 3
        x,y,z = instruction
        if x==-1 && y==0
            @score = z
        else
            @disp[y][x] = z
        end

        @ball_x = x if z==4
        @paddle_x = x if z==3
    end
    display(@disp, @score)
    @output.shift(processed)
end


while (computer.is_running) do
    if computer.awaiting_input && @input.empty?
        update_game()
        @input << (@ball_x <=> @paddle_x)
    else
        sleep(0.0001)
    end
end

update_game()

puts "GAME OVER"
puts "Score: #{@score}"

# p disp.reduce(0) {|sum, kv| sum+=kv[1].values.select{|x| x==2}.length} # num blocks (ans to part 1)

