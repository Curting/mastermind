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
    @guess = nil
    @guess_count = 0

    generate_code
  end
  
  def generate_code
    4.times { @code << rand(1..6) }
    puts "The code is: #{@code}"
  end

  def guess_and_evaluate
    puts "What's your guess?"
    @guess = gets.scan(/\d/)
    if valid_guess?
      evaluate
    else
      puts "What? I don't understand that. Give me 4 numbers between 1-6, please."
      guess_and_evaluate
  end

  def valid_guess?
    @guess.length == 4 &&  valid_guess_range?
  end

  def valid_guess_range? # Refactor
    valid = true
    @guess.each { |x| valid = false unless x.between?(1,6) }
    valid
  end

  def evaluate
    answer = [" ", " ", " ", " "]
    # Duplicate temp_code so it doesn't point directly to @code (destructive)
    temp_code = @code.dup

    # Correct color and position = ●
    temp_code.each_with_index do |x, index|
      if x == @guess[index]
        answer[index] = "●"
        # Remove the used color (to avoid false duplicates)
        temp_code[index] = nil
      end
    end

    # Correct color but WRONG position = ○
    @guess.each_with_index do |x, index|
      if temp_code.include?(x) && answer[index] != "●"
        answer[index] = "○"
        # Remove the used color by finding the index
        temp_code[temp_code.index(x)] = nil
      end
    end
    
    answer
  end

  def lost?
    @guess_count >= 12
  end

  def won?
    @guess == @code
  end

  def game_over?
    won? || lost?
  end

end

# Let the game begin!

game = Mastermind.new

puts "Welcome to Mastermind!"
puts "Your job is to guess my combination of 4 numbers within 12 guesses."
puts "Each number is between 1-6."
puts " "
puts "You will get feedback from me after each guess:"
puts " "
puts "● = Correct number and position."
puts "○ = The number exists in the combination but this is not the position."
puts "Nothing equals a wrong number."
puts " "
puts "You guess by writing the four numbers in any of these styles:"
puts "1234"
puts "1 2 3 4"
puts "1,2,3,4"
puts "1, 2, 3, 4"
puts "Or if you're really crazy: 1!NFH 2FNAWU88_3hmS,4. It's ok. I'll figure it out."
puts " "
puts "I'm thinking of a number combination now."





