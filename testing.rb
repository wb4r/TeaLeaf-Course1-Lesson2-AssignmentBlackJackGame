require 'pry'

player_hand = [["Hearts", "J"], ["Diamonds", "A"], ["Spades", "8"]]  

aces = 0

array_of_values = []

player_hand.each_index do |index, sub_array|
  if player_hand[index][1].to_i != 0
    array_of_values << player_hand[index][1].to_i
  elsif player_hand[index][1] == "A"
    array_of_values << 11
  else
    array_of_values << 10
  end
end

if array_of_values.inject(:+) > 21 && array_of_values.max == 11
  array_of_values.delete(11) 
  array_of_values.replace(array_of_values << 1)
end



p array_of_values
p array_of_values.inject(:+) + aces
p player_hand

