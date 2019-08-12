require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @guess = params[:guess]
    @letters = params[:letters].split(' ')
    if !check_guess(@guess, @letters)
      @result = 'You suck! You are using letters that are not in your grid.'
      points = 0
    elsif check_api(@guess) == false
      @result = 'You suck! You word is not an English word.'
      points = 0
    else
      time = params[:time]
      points = (@guess.length * 1000) - (Time.now - Time.parse(time)) * 10
      @result = "You won! Your score is #{points.round} !"
    end
    @result
  end

  private

  def call_api(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    attempt_serialized = open(url).read
    JSON.parse(attempt_serialized)
  end

  def check_api(guess)
    call_api(guess)["found"]
  end

  def check_guess(guess, letters)
    guess.upcase.split('').sort.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end
end
