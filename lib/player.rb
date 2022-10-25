require_relative 'word.rb'
require 'yaml'

class Player
  attr_accessor :guesses , :player_word  , :word , :characters
  def initialize
    @guesses = 7
    @word=Word.new.pick_random_word
    @player_word = get_unknown_word(word)
    @characters = []
  end

  def get_unknown_word(word)
    new_word = []
    word.length.times do
      new_word << "_"
    end
    new_word.join("")
  end

  def to_yaml
    YAML.dump(
      :guesses => @guesses,
      :word => @word,
      :player_word => @player_word,
      :characters => @characters
    )
  end
  
  def from_yaml(string)
    data = YAML.load_file("./saves/#{string}")
    @guesses = data[:guesses]
    @word = data[:word]
    @player_word = data[:player_word]
    @characters = data[:characters]
  end
end