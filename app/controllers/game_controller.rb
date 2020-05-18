require 'open-uri'

class GameController < ApplicationController

  def new
    @letters = (1..9).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    letters = params[:letters].split(' ')
    if !match_grid?(params[:word], letters)
      @score = "#{params[:word]} does not match the grid letters"
    elsif !english_word?(params[:word])
      @score = "#{params[:word]} is not an English word"
    else
      @score = "Congrats #{params[:word]} is a valid English word!"
    end
  end

  def match_grid?(word, letters)
    letters = params[:letters].split(' ')
    word.upcase.split('').each do |letter|
      if letters.include? letter
        letters.delete_at(letters.index(letter))
      else
        return false
      end
    end
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url).read
    word = JSON.parse(response)
    return false unless word['found']
    return true
  end
end
