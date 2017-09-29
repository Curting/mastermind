# A game is (8, 10 or) 12 rounds
# Six different colors
# Codemaker and a Codebreaker
# Codemaker chooses a pattern of four code pegs. Duplicates (and blanks) are allowed.
# The Codebreaker tries to guess the pattern.
# A colored key peg ● is placed for correct color and position
# A white key peg ○ is placed for correct color but wrong position
# If there are duplicate colors, they cannot all be awarded a key peg


class Mastermind

  attr_reader :play

  def initialize
    @code = []
    @guess = nil
    @guess_count = 0
    @rounds = nil
    @play = true

    generate_code
  end
  
  def generate_code
    4.times { @code << rand(1..6) }
  end

  def guess_and_evaluate
    if @guess_count == 0
      puts "What's your first guess?"
    else
      puts "You've got #{@rounds - @guess_count} guesses left."
      puts "What's your next guess?"
    end
    # Extract numbers (strings in array) and turn them into integers
    @guess = gets.scan(/\d/).map(&:to_i)

    if valid_guess?
      evaluate
      feedback(evaluate)
      @guess_count += 1
    else
      puts "What? I don't understand that. Give me 4 numbers between 1-6, please."
      guess_and_evaluate
    end
  end

  def valid_guess?
    @guess.length == 4 &&  valid_number_range?
  end

  def valid_number_range? # Refactor
    @guess.all? { |number| number.between?(1, 6) }
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

  def feedback(evaluation)
    puts "-----------------"
    puts "| #{@guess[0]} | #{@guess[1]} | #{@guess[2]} | #{@guess[3]} |"
    puts "-----------------"
    puts "| #{evaluation[0]} | #{evaluation[1]} | #{evaluation[2]} | #{evaluation[3]} |"
    puts "-----------------"
  end

  def lost?
    @guess_count >= @rounds
  end

  def won?
    @guess == @code
  end

  def game_over?
    won? || lost?
  end

  def ask_rounds
    puts "How many guesses do you want?"
    puts "Enter a number between 4-12."
    answer = gets.chomp.to_i
    if answer.between?(4, 12)
      @rounds = answer
      puts "Great. You have chosen #{@rounds} rounds. Good luck!"
    else
      puts "I don't understand that. Try again."
      puts " "
      ask_rounds
    end
  end

end

# Let the game begin!
game = Mastermind.new

puts "Welcome to Mastermind!"
puts " "
puts "Your job is to guess my combination of 4 numbers."
puts "Each number is between 1-6."
puts " "
game.ask_rounds
puts " "
puts "You will get feedback from me after each guess:"
puts " "
puts "● = Correct number and position."
puts "○ = The number exists in the combination but this is not the position."
puts "  = Wrong number."
puts " "
puts "You guess by writing the four numbers (between 1-6) like this:"
puts "1 2 3 4"
puts " "
puts "I'm thinking of a number combination now."

until game.game_over?
  game.guess_and_evaluate
end

game.won? ? puts("You won!!") : puts("You lost :-(")
