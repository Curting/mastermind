# A game is (8, 10 or) 12 rounds
# Six different colors
# Codemaker and a Codebreaker
# Codemaker chooses a pattern of four code pegs. Duplicates (and blanks) are allowed.
# The Codebreaker tries to guess the pattern.
# A colored key peg ● is placed for correct color and position
# A white key peg ○ is placed for correct color but wrong position
# If there are duplicate colors, they cannot all be awarded a key peg


class Mastermind

  def initialize
    @code = []
  end
  
  def generate_code
    4.times { @code << rand(1..6) }
  end

  

end