require "json"
require "rest-client"

class GamesController < ApplicationController
  def new
    @letters = generate_random_letters
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')

    @result = test_word(@word, @letters)
  end

  private
  
  def generate_random_letters
    letters_array = ('a'..'z').to_a
    
    game_array = []
    10.times do
      game_array << letters_array.sample.upcase
    end

    return game_array
  end

  def test_grid
    @word.split('').all? { |word| @letters.include?(word.upcase)}
  end

  def dictionary_test(word)
    response = RestClient.get "https://wagon-dictionary.herokuapp.com/#{word}"
    repos = JSON.parse(response)
    repos["found"]
  end

  def test_word(word, letters)
    if test_grid == true
      if dictionary_test(word) == true
        return "Congratulations! #{word.upcase} is a valid English Word!"
      else
        return "Sorry, but #{word.upcase} does not seem to be a valid English Word!"  
      end
    else
      return "Sorry, but #{word.upcase} can't be built out of #{letters}"  
    end
  end

end
