seen = {}
current_frequency = 0

loop do
  f = File.open('01_input', 'r')
  f.each_line do |x|
    current_frequency += x.to_i
    if seen.key?(current_frequency)
      puts current_frequency
      exit
    end
    seen[current_frequency] = 1
  end
  f.close
end
