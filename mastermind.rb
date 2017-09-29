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
    @rounds_count = 0

    generate_code
  end
  
  def generate_code
    4.times { @code << rand(1..6) }
    puts "The code is: #{@code}"
  end

  def evaluate(guess)
    answer = [" ", " ", " ", " "]
    # Duplicate temp_code so it doesn't point directly to @code (destructive)
    temp_code = @code.dup

    # Correct color and position = ●
    temp_code.each_with_index do |x, index|
      if x == guess[index]
        answer[index] = "●"
        # Remove the used color (to avoid false duplicates)
        temp_code[index] = nil
      end
    end

    # Correct color but WRONG position = ○
    guess.each_with_index do |x, index|
      if temp_code.include?(x) && answer[index] != "●"
        answer[index] = "○"
        # Remove the used color by finding the index
        temp_code[temp_code.index(x)] = nil
      end
    end

    @rounds_count += 1
    answer
  end



end

puts "Welcome to Mastermind!"
puts "Your job is to guess a combination of 4 numbers."
puts "Each number is between 1-6."
puts " "
puts "You will get feedback after each guess:"
puts " "
puts "● = Correct number and position."
puts "○ = The number exists in the combination but this is not the position."
puts "Nothing equals a wrong number."
puts " "




