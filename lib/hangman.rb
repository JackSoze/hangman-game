require 'yaml'

File.open('words.txt') # the words are pasted from google-10000-english-no-swears.txt dictionary file from the first20hours GitHub repository google-10000-english

# this is the game class
class Game
  def initialize
    @guess = 5
    @word = ''
    game_play
  end

  attr_accessor :letter, :guess, :word
  attr_accessor :wrong_letters, :dashes_arr
  def welcome_message
    puts 'welcome to the game Hangman'
    puts 'the rules are simple and as follows'
  end

  def save_game
    if self.letter == 'save'
      serialized_string = self.serialize_game
      unless File.exists?('saved_games') then Dir.mkdir('saved_games') end
      puts 'whats your name?'
      player_name = gets.chomp.downcase
      File.open("saved_games/saved_game.txt",'w'){|file|file.puts serialized_string}
    end
  end

  def game_start
    if Dir.exists?('saved_games')
      puts "Do you wish to play a saved game? 'yes'"
      answer = gets.chomp.downcase
      if answer == 'yes'
        deserialize_game
      end
    else
      puts 'No saved games; NEW GAME!'
      self.word = secret_word_selection
    end
  end

  def secret_word_selection
    word = File.readlines('words.txt').sample.delete_suffix('\n')
    puts word
    word
  end

  def player_letter_input
    puts 'Please input a letter between a->z'
    self.letter = gets.chomp.downcase
    save_game
  end

  def letter_check
    self.wrong_letters = []
    selected_word_arr = @word.split('')
    self.dashes_arr = []

    (word.length - 1).times { self.dashes_arr.push('_') }

    dashes = self.dashes_arr.join(' ')
    puts dashes
    until guess.zero?
      self.guess -= 1
      if selected_word_arr.include?(letter)
        selected_word_arr.each_with_index do |lettr, index|
          self.dashes_arr[index] = letter if lettr == letter
        end
      else
        self.wrong_letters.push(letter)
        puts "Incorrect letters: #{self.wrong_letters}"
      end
      puts self.dashes_arr.join(' ')
      puts "guesses remaining = #{self.guess}"
      player_letter_input
    end
  end

  def game_play
    game_start

    player_letter_input
    letter_check
  end

  def serialize_game
    YAML.dump({
      letter: @letter,
      guess: @guess,
      word: @word,
      wrong_letters: @wrong_letters,
      dashes_arr: @dashes_arr
    })
  end

  def deserialize_game
    serialized_game_string = File.read('saved_games/saved_game.txt')
    data = YAML.load(serialized_game_string)
    resetting_variables(data)
  end

  def resetting_variables(data)
    self.letter = data[:letter]
    self.guess = data[:guess]
    self.word = data[:word]
    self.wrong_letters = data[:wrong_letters]
    self.dashes_arr = data[:dashes_arr]
  end
end

game = Game.new

# puts welcome message

# if old games exists, ask the player if they want to play an old game or a new game
#
# otherwise play a new game
# through all iterations, allow the play to input 'save' to save game state
# to save a game, serialize the game and save it in a folder with the player name

