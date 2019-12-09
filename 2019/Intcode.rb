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

  attr_accessor :program, :instruction_pointer, :input, :output
  def initialize(program, input, output)
    @program = program
    @input = input
    @output = output
    @instruction_pointer = 0
  end

  def get_params()
    opcode = @program[@instruction_pointer]
    params = []
    (1..NUM_PARAMS[opcode%100]).each do |i|
      if ((opcode / (10**(i+1))) % 10 == 1) # immediate mode
        params << @program[@instruction_pointer+i]
      else # position mode
        params << @program[@program[@instruction_pointer+i]]
      end
    end
    params
  end

  def run
    all_outputs = []
    loop do
      opcode = @program[@instruction_pointer] % 100

      params = get_params()
      if opcode == 1
        @program[@program[@instruction_pointer+3]] = params[0] + params[1]
      elsif opcode == 2
        @program[@program[@instruction_pointer+3]] = params[0] * params[1]
      elsif opcode == 3
        @program[@program[@instruction_pointer+1]] = @input.shift
      elsif opcode == 4
        all_outputs << params[0]
        @output << params[0]
      elsif opcode == 5 # jump-if-true
        next (@instruction_pointer = params[1]) if params[0] != 0
      elsif opcode == 6 # jump-if-false
        next (@instruction_pointer = params[1]) if params[0] == 0
      elsif opcode == 7 # less than
        @program[@program[@instruction_pointer+3]] = params[0] < params[1] ? 1 : 0
      elsif opcode == 8 # equals
        @program[@program[@instruction_pointer+3]] = params[0] == params[1] ? 1 : 0
      elsif opcode == 99
        p "all_outputs: #{all_outputs}"
        return
      end
      @instruction_pointer += params.length + 1
    end
  end
end