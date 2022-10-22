# frozen_string_literal: true

# require 'pry-byebug'

module UsefulMethods
  def key_valid(key)
    pattern = /^[1-6]{4}$/
    pattern.match?(key)
  end

  def error_message
    puts 'Enter valid secret key'
  end

  def winning_message
    puts 'You broke the secret code'
  end
end

class Choice
  attr_accessor :codebreaker, :codemaker

  def initialize
    @codebreaker = nil
    @codemaker = nil
  end

  def codebreaker_or_codemaker
    puts 'Press 1 to be a codebreaker and 2 to be a codemaker!'
    input = gets.chomp

    case input
    when '1'
      @codebreaker = 'human'
      @codemaker = 'machine'

    when '2'
      @codebreaker = 'machine'
      @codemaker = 'human'

    else
      send_error_message
    end
  end

  def error_message
    puts 'Plz press valid input'
    codebreaker_or_codemaker
  end
end

class Codemaker
  include UsefulMethods

  attr_accessor :secretkey

  def self.generate_secret_key
    @secretkey = ''
    4.times { @secretkey += rand(1..6).to_s }
    @secretkey
  end

  def self.enter_secret_key
    puts 'Enter valid secret key'
    input = gets.chomp
    if(key_valid(input) == true) 
      @secretkey = input  
    else
      error_message
      Codemaker.secretkey
    end
  end
end

class Feedback
  def self.hint(secretkey, triedkey)
    secretkey_array = secretkey.split('')
    triedkey_array = triedkey.split('')
    pegs = []
    pruned_secretkey_array = []
    pruned_triedkey_array = []

    (0..3).each do |index|
      if secretkey_array[index] == triedkey_array[index]
        pegs.push('B')
      else
        pruned_secretkey_array.push(secretkey_array[index])
        pruned_triedkey_array.push(triedkey_array[index])
      end
    end

    pruned_triedkey_array.uniq.each do |element|
      k_times = pruned_secretkey_array.count(element)
      pegs.push('W' * k_times) if k_times.positive?
    end
    display(pegs) unless pegs == ['B','B','B','B']
    pegs
  end

  def self.display(pegs)
    pegs.each{|peg| print peg}
    puts
  end
end

class HumanCodebreaker
  include UsefulMethods

  def input_code
    puts 'Enter your code'
    input = gets.chomp
    unless key_valid(input) == true
      puts 'Try again'
      input_code
    else
      input
    end
  end

  def play
    secretkey = Codemaker.generate_secret_key
    p secretkey
    (1..12).each do |index|
      triedkey = input_code
      if Feedback.hint(secretkey, triedkey) == ['B','B','B','B']
        winning_message
        break
      end
    end

    puts "The secret key was #{secretkey}"
  end
end

human = HumanCodebreaker.new
human.play
