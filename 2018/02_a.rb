def freq(str)
  count = Hash.new 0
  str.each_char do |letter|
    count[letter] = count[letter] + 1
  end
  count
end

input = File.readlines('02_input')
freqs = input.map { |x| freq x }
total = freqs.reduce(Hash.new(0)) do |acc, char_frequencies|
  acc[2] += 1 if char_frequencies.value? 2
  acc[3] += 1 if char_frequencies.value? 3
  acc
end

puts total[2] * total[3]
