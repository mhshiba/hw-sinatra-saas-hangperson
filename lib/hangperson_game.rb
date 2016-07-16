class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
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
      if @word.downcase.include? letter_low
        @guesses += letter_low
      else
        @wrong_guesses += letter_low
      end
      valid = true
    end
    valid
  end
  
  def word_with_guesses
    retval = ''
    @word.chars do |s|
      if @guesses.include? s
        retval += s
      else
        retval += '-'
      end
    end
    retval
  end
  
  def check_win_or_lose
    check = :play
    if word_with_guesses == @word and @wrong_guesses.length < 7
      check = :win
    elsif @wrong_guesses.length >= 7
      check = :lose
    end
    check
  end

end
