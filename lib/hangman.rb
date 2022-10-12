
File.open('words.txt') #the words are pasted from google-10000-english-no-swears.txt dictionary file from the first20hours GitHub repository google-10000-english

class Game

  def initialize
   game_play
  end

  def secret_word_selection
    word = ""
    until word.length > 5 && word.length < 12
    word = File.readlines('words.txt').sample.delete_suffix('\n')
    end
    word
  end

  def game_play
    #display dashes according to the word.length
    word = secret_word_selection
    split_word = word.split('')

    puts word
    array = []
    (word.length-1).times{array.push('_')}
    dashes = array.join(' ')


    #ask the player to input a letter
    puts 'Please input a letter between a->z'
    letter = gets.chomp.downcase
    #if the word.include(letter), replace the dash in letter position
    if split_word.include?(letter)
      array[split_word.index(letter)] = letter
    end
    puts array
    puts array.join(' ')

    #if not, subtract the guess by 1 and post the letter to an array
    #repeat until word is complete or gusses end
  end


end
game = Game.new
