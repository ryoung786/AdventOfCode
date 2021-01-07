input = File.read(File.dirname(__FILE__) + '/input')
min_zeros = 9999999999
min_zeros_index = -1
input.chars.each_slice(25*6).with_index.each do |x,i|
  zeros = x.map(&:to_i).select(&:zero?).count
  if zeros < min_zeros
    min_zeros = zeros
    min_zeros_index = i
  end
end

layer = input.chars.each_slice(25*6).to_a[min_zeros_index]
freqs = layer.reduce(Hash.new(0)) {|h,x| h[x]+=1; h}
p freqs['1'] * freqs['2']



final = ('2' * (25*6)).chars.map(&:to_i)
layers = input.chars.map(&:to_i).each_slice(25*6).to_a
foo = layers.reduce(final) do |acc, layer|
  acc.each_with_index.map do |x,i| 
    (x==2) ? layer[i] : x
  end
end




foo.each_slice(25) do |x|
  p (x.join('').gsub('0',' ').gsub('1','*')) # KCGEC
end