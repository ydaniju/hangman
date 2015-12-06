require 'pry'
require 'stringio'
# Hangman module
module Hangman
  # This class starts and ends game
  class Game
    attr_accessor :right_guess, :wrong_count, :show, :total_lives, :play, :word,
    :display, :save, :entry
    def initialize
      @right_guess = ''
      @wrong_count = 0
      @total_lives = 7
      @play = Hangman::Play.new
      @word = Hangman::Choice.new.pick_word
      @display = @play.show_word(@word, @right_guess)
      @show = Hangman::Show.new
      @save = Hangman::Save.new(self)
    end

    def pre_start
      puts @show.begin
      @entry = gets.strip.downcase
      case @entry
      when 'start' then start!
      when 'load' then @save.load_data
      else
        exit
      end
    end

    def start!
      puts 'Which word is:' + @play.show_word(@word, '') + '?'
      while @wrong_count < @total_lives
        print "You have #{@total_lives - @wrong_count} chances left. "
        char = @play.enter_guess
        if char.match(/[^a-zA-Z0-9_]/)
          save_options
        elsif @word.include? char
          right_entry(char)
        else
          wrong_entry(char)
        end
      end
    end

    def save_options
      puts @show.save_or_quit?
      options = gets.strip.downcase
      case options
      when 's' then save_data(start!)
      when 'c' then save_data(start!)
      else
        exit
      end
    end

    def right_entry(char)
      if @right_guess.include? char
        puts char + ' is already given and accepted.'
        puts 'Try another: ' + @play.show_word(@word, @right_guess)
      else
        @right_guess += char
        puts @show.show_right_entry + @play.show_word(@word, @right_guess)
      end
      abort(@show.show_win) unless
        @play.show_word(@word, @right_guess).include? '*'
    end

    def wrong_entry(char)
      puts "Sorry! The word doesn't contain '#{char}'"
      @wrong_count += 1
      if @wrong_count == @total_lives
        puts "#{@word} + '\n' + #{@show.hang}"
        full_game
      else
        puts @show.show_wrong_entry + @play.show_word(@word, @right_guess)
      end
    end

    def full_game
      puts @show.continue
      play_on = gets.downcase.strip
      if play_on == 'y'
        @word = Hangman::Choice.new.pick_word
        @wrong_count = 0
        @total_lives = 7
        @right_guess = ''
        start!
      end
    end
  end
end
