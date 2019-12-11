class Intcode
  NUM_PARAMS = {
    1 => 3,
    2 => 3,
    3 => 1,
    4 => 1,
    5 => 2,
    6 => 2,
    7 => 3,
    8 => 3,
    99 => 0
  }

  attr_accessor :id, :input, :output
  def initialize(program, input, output, id)
    @id = id
    @program = program
    @input = input
    @output = output
    @instruction_pointer = 0
    @relative_base = 0
  end

  def get_params()
    instruction = @program[@instruction_pointer]
    params = []
    (1..NUM_PARAMS[instruction%100]).map do |i|
      mode = (instruction / (10**(i+1))) % 10
      next @program[@instruction_pointer+i] if mode==0 # position mode
      next @instruction_pointer+i if mode==1 # immediate mode
      next @instruction_pointer+i if mode==2 # relative mode
    end
  end

  def run
    all_outputs = []
    loop do
      opcode = @program[@instruction_pointer] % 100
      params = get_params()

      if opcode == 1
        @program[params[2]] = @program[params[0]] + @program[params[1]]
      elsif opcode == 2
        @program[params[2]] = @program[params[0]] * @program[params[1]]
      elsif opcode == 3
        sleep 0.01 while @input.empty?
        @program[params[0]] = @input.shift
      elsif opcode == 4
        all_outputs << @program[params[0]]
        @output << @program[params[0]]
      elsif opcode == 5 # jump-if-true
        next (@instruction_pointer = @program[params[1]]) if @program[params[0]] != 0
      elsif opcode == 6 # jump-if-false
        next (@instruction_pointer = @program[params[1]]) if @program[params[0]] == 0
      elsif opcode == 7 # less than
        @program[params[2]] = @program[params[0]] < @program[params[1]] ? 1 : 0
      elsif opcode == 8 # equals
        @program[params[2]] = @program[params[0]] == @program[params[1]] ? 1 : 0
      elsif opcode == 99
        return
      end
      @instruction_pointer += params.length + 1
    end
  end
end