File.open('words.txt') # the words are pasted from google-10000-english-no-swears.txt dictionary file from the first20hours GitHub repository google-10000-english

class Game
  def initialize

    @guess = 5
    @word = ''
    game_play
  end

  attr_accessor :letter, :guess, :word

  def secret_word_selection

    word = File.readlines('words.txt').sample.delete_suffix('\n')
    puts word
    word
  end

  def player_letter_input
    puts 'Please input a letter between a->z'
    self.letter = gets.chomp.downcase
  end

  def letter_check


    wrong_letters = []
    selected_word_arr = @word.split('')
    dashes_arr = []

    (word.length - 1).times { dashes_arr.push('_') }

    dashes = dashes_arr.join(' ')
    puts dashes
    until guess == 0
      self.guess -= 1
      if selected_word_arr.include?(letter)

        selected_word_arr.each_with_index do |lettr, index|
          dashes_arr[index] = letter if lettr == letter
        end
        puts dashes_arr.join(' ')
        player_letter_input
      else
        wrong_letters.push(letter)
        puts "Incorrect letters: #{wrong_letters}"
        letter = gets.chomp.downcase

      end
    end
  end

  def game_play
    # display dashes according to the word.length
    self.word = secret_word_selection



    # ask the player to input a letter
    player_letter_input
    letter_check
  end

  # if not, subtract the guess by 1 and post the letter to an dashes_arr
  # repeat until word is complete or gusses end
end
game = Game.new
