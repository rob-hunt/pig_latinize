input_array = ARGV

puts input_array.length
puts input_array.to_s

first_arg, *the_rest = ARGV
puts "first_arg = #{first_arg}"
puts "the_rest = #{the_rest}"