class Mastermind

  def initialize
    @code = []
    @guess = nil
    @guess_count = 0
    @rounds = nil

    welcome_message
    play_game
  end
    
  def play_game
    generate_code

    until game_over?
      guess_and_evaluate
    end

    won? ? puts("You won!!") : puts("You lost :-(")
    sleep(3)
    puts "\nLet's play again?"
    sleep(2)
    reset
    play_game
  end

  def welcome_message
    puts "\nWelcome to Mastermind!"
    puts "\nYour job is to guess my combination of 4 numbers."
    puts "Each number is between 1-6."
    ask_rounds
    puts "\nYou will get feedback from me after each guess:"
    puts "\n● = Correct number and position."
    puts "○ = The number exists in the combination but this is not the position."
    puts "  = Wrong number."
    puts "\nYou guess by writing the four numbers (between 1-6) like this:"
    puts "1 2 3 4"
    puts "\nI'm thinking of a number combination now."
  end

  def play_mode
    puts "Do you want to be the Codemaker or the Codebreaker?"
    puts ">> [1] Codemaker"
    puts ">> [2] Codebreaker"
    input = gets.chomp.to_i
    until input == 1 || input == 2
      "What? Type 1 for Codemaker or 2 for Codebreaker, please:"
      input = gets.chomp.to_i
    end
    input == 1 ? @player = Codemaker.new : @player = Codebreaker.new
  end

  private

  def reset
    @code = []
    @guess = nil
    @guess_count = 0
    @rounds = nil
    ask_rounds
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
    puts "\nHow many guesses do you want?"
    puts "Enter a number between 4-12."
    answer = gets.chomp.to_i
    if answer.between?(4, 12)
      @rounds = answer
      puts "Great. You have chosen #{@rounds} rounds. Good luck!"
    else
      puts "\nI don't understand that. Try again."
      puts " "
      ask_rounds
    end
  end

end

class Codebreaker < Mastermind
  def initialize
    @code = []
    @guess = nil
    @guess_count = 0
    @rounds = nil
  end

  
end

# Let the game begin!
game = Mastermind.new
