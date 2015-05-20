require 'pry'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'guessr/version'
require 'guessr/init_db'
require 'guessr/menu'

## Number Guessing Game
#* New Game
#* Existing Game

#* New Game
#* Ask them to choose player
#* Each turn, they can guess a number or quit

#* Existing Game
#* Each turn, they can guess a number or quit

module Guessr
  class Player < ActiveRecord::Base
    has_many :games
    #:scores? :games_played?
  end

  class Game < ActiveRecord::Base
    belongs_to :player

    def scoring
        users_score = 0

    end

    def game_over?
      self.answer == self.last_guess
    end

    def play
      until self.game_over?
        puts "Please guess a number (or quit with 'q'): "
        result = gets.chomp
        if result == 'q'
          exit
        else
          self.turn(result)
        end
      end
    end

    def turn(guess)
      self.update(last_guess: guess.to_i,
                  guess_count: self.guess_count + 1)
      if self.last_guess > self.answer
        puts "Too high!"
      elsif self.last_guess < self.answer
        puts "Too low!"
      else
        puts "You win!"
         round_total = 100 - (10 * guess_count)
        #  users_score = round_total.to_i + users_score.to_i
         puts "Your score for this: #{round_total}"
         self.player.update(score: self.player.score + round_total)
         puts "Your total score is: #{self.player.score}"

         self.update(finished: true)


      end
    end
  end
end


menu = Guessr::Menu.new
menu.run
