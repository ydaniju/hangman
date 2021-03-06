module Hangman
  class Play
    def show_word(picked_word, guess)
      display = ''
      picked_word.chars do |char|
        display += if guess.include? char
                     char
                   else
                     '*'
                   end
      end
      display
    end

    def enter_guess
      entry = ''
      loop do
        puts 'Please  enter a letter'
        entry = gets.chomp.downcase
        break if entry.match(/^\D*$/) && entry.length == 1
      end
      entry
    end
  end
end
