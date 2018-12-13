require 'text'

input = File.readlines('02_input')

input.each do |a|
  input.each do |b|
    if Text::Levenshtein.distance(a, b) == 1
      puts a
      puts b
      exit
    end
  end
end
