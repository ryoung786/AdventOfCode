require_relative '../Intcode'
input = File.read(File.dirname(__FILE__) + '/input')

program = input.split(',').map(&:to_i)

# program = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
p program.length
# program = [1102,34915192,34915192,7,4,7,99,0]
# program = [104,1125899906842624,99]
out = []
i = Intcode.new(program, [2], out, 1)
i.run
p out