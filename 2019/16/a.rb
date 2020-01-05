input = 12345678
input = 80871224585914546619083218645595 # 24176176
input = 19617804207202209144916044189917 # 73745418
input = 69317163492948606335995924319873 # 52432133
input = File.read(File.dirname(__FILE__) + '/input').to_i
input = input.to_s

def pattern_for_pos(pos, size)
  pattern = [0, 1, 0, -1]
  pattern = pattern.map{|i| x=[]; pos.times{x<<i}; x}
  pattern.flatten.cycle.take(size+1).drop(1)
end

patterns = []
(1..input.length).each do |i|
  patterns[i] = pattern_for_pos(i,input.length)
end

phases = 100

phases.times do |n|
  foo = (1..input.length).map do |i|
    # zipped = input.chars.map(&:to_i).zip(pattern_for_pos(i, input.length))
    zipped = input.chars.map(&:to_i).zip(patterns[i])
    zipped = zipped.map{|p| p[0]*p[1]}
    zipped = zipped.reduce(&:+)
    zipped.abs % 10
  end
  input = foo.join
  p "After #{n+1} phases: #{input.chars.take(8).join}"
end
