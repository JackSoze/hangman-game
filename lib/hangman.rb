require 'yaml'

File.open('words.txt') # the words are pasted from google-10000-english-no-swears.txt dictionary file from the first20hours GitHub repository google-10000-english

# this is the game class
class Game
  def initialize
    @guess = 10
    @word = ''
    game_play
  end

  attr_accessor :letter, :guess, :word, :wrong_letters, :dashes_arr

  def welcome_message
    puts 'welcome to the game Hangman'
    puts 'the rules are simple and as follows'
  end

  def save_game
    return unless self.letter == 'save'

    serialized_string = self.serialize_game
    Dir.mkdir('saved_games') unless File.exist?('saved_games')

    File.open('saved_games/saved_game.txt', 'w') { |file| file.puts serialized_string }
  end

  def game_select
    if Dir.exist?('saved_games')
      puts "Do you wish to play a saved game? 'yes'"
      answer = gets.chomp.downcase
      if answer == 'yes'
        deserialize_game
        puts "#{self.word} guesses remaining: #{guess}"
        puts self.dashes_arr.join(' ')
      else
        puts 'Playing a new game'
        self.word = secret_word_selection
      end
    else
      puts 'No saved games; NEW GAME!'
      self.word = secret_word_selection
    end
  end

  def secret_word_selection
    self.word = File.readlines('words.txt').sample.delete_suffix("\n")
    puts word
    self.dashes_arr = []
    (word.length).times { self.dashes_arr.push('_') }
    dashes = self.dashes_arr.join(' ')
    puts dashes
    word
  end

  def player_letter_input
    puts 'Please input a letter between a->z'
    self.letter = gets.chomp.downcase
    save_game
  end

  def play_game
    self.wrong_letters = []
    selected_word_arr = self.word.split('')
    puts "the word is #{}"

    until guess.zero? || letter == 'save'
      self.guess -= 1
      if selected_word_arr.include?(letter)
        selected_word_arr.each_with_index do |lettr, index|
          self.dashes_arr[index] = letter if lettr == letter
        end
      else
        self.wrong_letters.push(letter) unless letter == 'save'
        puts "Incorrect letters: #{self.wrong_letters}"
      end
      puts self.dashes_arr.join(' ')
      puts "guesses remaining = #{self.guess}"
      puts "#{selected_word_arr} and #{dashes_arr}"
      break if selected_word_arr == self.dashes_arr
      player_letter_input

    end
  end

  def game_play
    game_select
    player_letter_input
    play_game
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
