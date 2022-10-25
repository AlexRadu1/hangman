require_relative 'player.rb'


class Game
  attr_accessor :player 
  def initialize
    @player = Player.new
    @loading_state = nil
    @save_check = false
    @file_name = nil
  end

  def save_or_load
    puts "Do you want to:1)Start new game(type 1)"
    puts "               2)Load an old game(type 2)"
    @loading_state = gets.chomp.to_i
    if @loading_state == 2
      select_file
      file = gets.chomp
      load_game(file)
    end
  end

  def load_game(name)
    player.from_yaml(name)

  end

  def select_file
    puts "Choose your file to load"
    filenames = Dir.entries("./saves")
    filenames.each { |file| puts file}
  end

  def show_info
    puts "---------------------------------------------------------------"
    puts "Tries left: #{player.guesses}"
    puts "Letters already guessed: #{player.characters.join(" ")}"
    puts player.player_word
    puts "Enter your Letter(or type \"save\" to save the game and exit): "
    input = gets.chomp
    check_input(input)
  end

  def check_input(input)
    if input == "save"
      @save_check = true
      return
    end
    if !player.characters.include?(input)
      if player.word.include?(input)
        player.word.split("").each_with_index do |x,index| 
          if x == input 
            player.player_word[index] = x
            if !player.characters.include?(input)
              player.characters << input
            end
          end  
        end
      else
        player.guesses-=1
        player.characters << input
      end
    else
      if player.characters.include?(input)
        puts "You already said \"#{input}\".Try again!"
      else
        puts "Illegal character.Only one letter at the time allowed!"
      end
    end
  end

  def save_game(name)
    begin
      File.open("./saves/#{name}", "w") do |file|
        file.write(player.to_yaml)
      end  
    rescue IOError => e
      #some error occur, dir not writable etc.
    end
  end 

  def play
    loop do 
      if !player.word.eql?(player.player_word)
        if @save_check == true
          puts "Choose save file name: "
          file_name = gets.chomp
          save_game(file_name)
          break
        end
        if player.guesses == 0
          puts "You lost the word was: #{player.word}"
          break 
        end
        show_info()
      else
        puts "Congratulation you won!The word was #{player.word}"
        return
      end
    end
  end

  def start
    save_or_load()
    play()
  end
end