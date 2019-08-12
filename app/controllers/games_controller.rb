require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def call_api
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    attempt_serialized = open(url).read
    JSON.parse(attempt_serialized)
  end

  def check_api
    call_api["found"]
  end

  def check_guess
    @guess = params[:guess]
    @letters = params[:letters].split(' ')
    @guess.upcase.split('').sort.all? { |letter| @guess.count(letter) <= @letters.count(letter) }
  end

  def score
      if !check_guess
        @result = 'You suck! You are using letters that are not in your grid.'
      elsif check_api == false
        @result = 'You word is not an English word'
      else @result = 'You won!'
    end
  end
end
