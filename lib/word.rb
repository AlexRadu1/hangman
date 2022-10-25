class Word
  attr_accessor :list_of_words , :valid_words
  def initialize
    @list_of_words = File.readlines('google-10000-english-no-swears.txt')
    @valid_words = []
    list_of_words.each do |word|
      word.delete!("\n")
      if word.length >= 5 && word.length <= 12
        valid_words << word
      end
    end 
  end
  
  def pick_random_word
    valid_words.sample
  end
end