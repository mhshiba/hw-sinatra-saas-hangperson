class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  attr_reader :word_with_guesses
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
    @guess_number = 0
    @word_with_guesses = '-' * @word.length
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
  
  def guess(letter)
    raise ArgumentError, "Guessed letter can't be nil" if letter == nil
    raise ArgumentError, "Guessed letter can't be empty" if letter.empty?
    raise ArgumentError, "Guessed letter must be a letter" unless letter.match(/[a-z]/i)
    
    letter_low = letter.downcase
    # A letter that has already been guessed
    # or is a non-alphabet character is considered "invalid"
    if @guesses.include? letter_low or @wrong_guesses.include? letter_low or
      letter_low.match(/[^a-z]/i)
      valid = false
    else
      # If the word contains this letter
      if @word.downcase.include? letter_low
        @guesses += letter_low
        # Update word with guesses until now
        # Replacing it with current letter
        i = -1
        while i = @word.index(letter_low, i + 1) do
          @word_with_guesses[i] = letter_low
        end
      else
        @wrong_guesses += letter_low
      end
      valid = true
      @guess_number += 1
    end
    valid
  end
  
  def check_win_or_lose
    check = :play
    if @guess_number >= 7
      check = :lose
    elsif @word_with_guesses == @word and @guess_number < 7
      check = :win
    end
    check
  end

end
