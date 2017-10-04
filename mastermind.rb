class Mastermind
  attr_accessor :rounds

  def initialize
    @code = []
    @guess = nil
    @guess_count = 0
    @rounds = nil
    @feedback = nil
  end
    
  def play_game
    play_mode
    puts "Got 'ya. And how many guesses do we play with?"
    ask_rounds
    @player.generate_code

    until @player.game_over?
      @player.guess_and_evaluate
    end

    @player.game_over_message
    sleep(3)
    puts "\nThe game will reboot now to let you play again."
    sleep(2)
    reset
    play_game
  end

  def play_mode
    puts "\nWelcome to...\n"
    sleep(1)
    puts " __  __           _                      _           _ "
    puts "|  \\/  | __ _ ___| |_ ___ _ __ _ __ ___ (_)_ __   __| |"
    puts "| |\\/| |/ _` / __| __/ _ \\ '__| '_ ` _ \\| | '_ \\ / _` |"
    puts "| |  | | (_| \\__ \\ ||  __/ |  | | | | | | | | | | (_| |"
    puts "|_|  |_|\\__,_|___/\\__\\___|_|  |_| |_| |_|_|_| |_|\\__,_|"                                                     

    sleep(1)
    instructions
    sleep(2)
    puts "\nDo you want to be the Codemaker or the Codebreaker?"
    puts ">> [1] Codemaker"
    puts ">> [2] Codebreaker"
    input = gets.chomp.to_i
    until input == 1 || input == 2
      "What? Type 1 for Codemaker or 2 for Codebreaker, please:"
      input = gets.chomp.to_i
    end
    input == 1 ? @player = Codemaker.new : @player = Codebreaker.new
  end

  protected

  def instructions
    puts "\nThe Gamebreaker's job is to guess the Gamemaker's combination of 4 numbers."
    puts "Each number is between 1-6."
    puts "\nThe Gamebreaker will get feedback after each guess:"
    puts "\n● = Correct number and position."
    puts "○ = The number exists in the combination but this is not the position."
    puts "  = Wrong number."
    puts "\nThe Gamebreaker will guess by writing the four numbers (between 1-6) like this:"
    puts "1 2 3 4"
  end

  def game_over_message
    won? ? puts("#{@type.upcase} WON!! :-)") : puts("#{@type} lost! :-/")
  end

  def reset
    @code = []
    @guess = nil
    @guess_count = 0
    @rounds = nil
  end

  def valid_input?(input)
    input.length == 4 &&  valid_number_range?(input)
  end

  def valid_number_range?(input) # Refactor
    input.all? { |number| number.between?(1, 6) }
  end

  def evaluate(input, answer)
    feedback = [" ", " ", " ", " "]
    # Duplicate temp_code so it doesn't point directly to @code (destructive)
    temp_code = answer.dup

    # Correct color and position = ●
    temp_code.each_with_index do |x, index|
      if x == input[index]
        feedback[index] = "●"
        # Remove the used color (to avoid false duplicates)
        temp_code[index] = nil
      end
    end

    # Correct color but WRONG position = ○
    input.each_with_index do |x, index|
      if temp_code.include?(x) && feedback[index] != "●"
        feedback[index] = "○"
        # Remove the used color by finding the index
        temp_code[temp_code.index(x)] = nil
      end
    end

    feedback
  end

  def show_board
    puts "-----------------"
    puts "| #{@guess[0]} | #{@guess[1]} | #{@guess[2]} | #{@guess[3]} |"
    puts "-----------------"
    puts "| #{@feedback[0]} | #{@feedback[1]} | #{@feedback[2]} | #{@feedback[3]} |"
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
    puts "Enter a number between 4-12."
    answer = gets.chomp.to_i
    if answer.between?(4, 12)
      @player.rounds = answer
      puts "Great. You have chosen #{@player.rounds} rounds."
    else
      puts "\nI don't understand that. Try again."
      puts " "
      ask_rounds
    end
  end

end

class Codebreaker < Mastermind

  attr_reader :type

  def initialize
    @type = "You"
    super
  end

  def ask_rounds
    puts "\nHow many guesses would you like?"
    super
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

    if valid_input?(@guess)
      @feedback = evaluate(@guess, @code)
      show_board
      @guess_count += 1
    else
      puts "What? I don't understand that. Give me 4 numbers between 1-6, please."
      guess_and_evaluate
    end
  end
  
end

class Codemaker < Mastermind
  attr_reader :type

  def initialize
    @solutions = generate_solutions
    @feedback = nil
    @type = "The computer"
    super
  end

  def ask_rounds
    puts "\nHow many guesses does the Gamebreaker have?"
    super
  end

  def generate_code
    puts "\nEnter your secret combination of 4 numbers (1-6):"

    # Turn answer ("1234" etc.) to an array [1, 2, 3, 4]
    answer = gets.chomp.scan(/\d/).map(&:to_i)
    until valid_input?(answer)
      puts "I don't understand your code. Please try again."
      generate_code
    end
    @code = answer
  end

  def generate_solutions
    solutions = []

    1296.times do |x|
      loop do
        answer = [rand(1..6), rand(1..6), rand(1..6), rand(1..6)]
        if !solutions.include?(answer)
          solutions << answer
          break
        end
      end
    end

    solutions.sort
  end

  def guess_and_evaluate
    if @guess_count == 0
      puts "The computer is thinking about it's first guess..."
      sleep(2)
    else
      puts "The computer has #{@rounds - @guess_count} guesses left."
      puts "It's thinking about it's next guess..."
      sleep(2)
    end

    # Guess, get feedback and show board
    @guess = guess_algorithm
    @feedback = evaluate(@guess, @code)
    show_board
    @guess_count += 1
  end
  
  def guess_algorithm
    possible_solutions = []
    if @guess_count == 0
      @solutions.delete([1, 1, 2, 2])
    else
      # If the code is |solution|, would I have gotten the previous
      # feedback? If true, add it to an array of possible solutions
      @solutions.each do |solution|
        possible_solutions << solution if evaluate(@guess, solution) == @feedback
      end
      # Let @solutions only consist of possible solutions
      @solutions = possible_solutions.dup

      # Let next guess be one of the remaining possible solutions and remove it
      @solutions.delete(@solutions.sample)
    end
  end
end

# Let the game begin!
game = Mastermind.new
game.play_game
