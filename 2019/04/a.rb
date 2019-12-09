low = '359282'
high = '820401'
r = (low.to_i ... high.to_i)

def increasing?(num)
  x = num.to_s.chars #.map(&:to_i)
  x == x.sort
end

def doubled?(num)
  x = num.to_s.chars
  x.length > x.uniq.length
end

foo = r.select {|x| increasing?(x) && doubled?(x)}
p foo
p foo.length

def only_doubled?(num)
  x = num.to_s.chars
  x.reduce(Hash.new(0)) {|acc, digit| acc[digit]+=1; acc}.values.include? 2
end

foo = r.select {|x| increasing?(x) && only_doubled?(x)}
p foo
p foo.length