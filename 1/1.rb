#! ruby

input = File.read('input.txt').lines.map { |x| x.strip.to_i }

pairs = input.combination(2)

x, y = pairs.find { |x, y| x + y == 2020 }

puts "Part 1:"
puts "#{x} + #{y} == 2020"
puts "#{x} * #{y} == #{x * y}"
puts

trios = input.combination(3)

x, y, z = trios.find { |x, y, z| x + y + z == 2020 }

puts "Part 2:"
puts "#{x} + #{y} + #{z} == 2020"
puts "#{x} * #{y} * #{z} == #{x * y * z}"
puts
