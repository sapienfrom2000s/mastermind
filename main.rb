# frozen_string_literal: true

# require 'pry-byebug'

class UsefulMethods
  def key_valid?(key)
    pattern = /^[1-6]{4}$/
    pattern.match?(key)
  end

  def error_message
    puts 'Sorry, that was invalid!'
  end

  def winning_message(winner)
    puts "#{winner} broke the secret code"
  end
end

class Choice 
  def codebreaker_or_codemaker
    puts 'Press 1 to be a codebreaker and 2 to be a codemaker!'
    input = gets.chomp

    case input
    when '1'
      human = HumanCodebreaker.new
      machine = Codemaker.new
      secretkey = machine.generate_secretkey
      human.play(secretkey)

    when '2'
      human = Codemaker.new
      secretkey = human.enter_secretkey
      machine = MachineCodebreaker.new
      machine.play(secretkey)
    else
      puts 'Plz press valid input'
      codebreaker_or_codemaker
    end
  end
end

class Codemaker < UsefulMethods

  attr_accessor :secretkey

  def generate_secretkey
    @secretkey = ''
    4.times { @secretkey += rand(1..6).to_s }
    @secretkey
  end

  def enter_secretkey
    puts 'Enter valid secret key'
    input = gets.chomp

    if key_valid?(input)
      @secretkey = input
    else
      error_message
      enter_secretkey
    end
  end
end

class Feedback
  attr_accessor :pegs

  def hint(secretkey, triedkey)
    secretkey_array = secretkey.split('')
    triedkey_array = triedkey.split('')
    pegs = []
    pruned_secretkey_array = []
    pruned_triedkey_array = []

    4.times do |index|
      if secretkey_array[index] == triedkey_array[index]
        pegs.push('B')
      else
        pruned_secretkey_array.push(secretkey_array[index])
        pruned_triedkey_array.push(triedkey_array[index])
      end
    end

    pruned_triedkey_array.each do |element|
      if index = pruned_secretkey_array.find_index(element)
        pegs.push('W')
        pruned_secretkey_array.delete_at(index)
      end
    end
    # display(pegs) unless pegs.join == 'BBBB'
    self.pegs = pegs
  end

  def display
    pegs.each { |peg| print peg }
    puts
  end
end

class HumanCodebreaker < UsefulMethods
  # include UsefulMethods

  def input_code
    puts 'Enter your code'
    input = gets.chomp
    if key_valid?(input)
      input
    else
      error_message
      input_code
    end
  end

  def play(secretkey)
    (1..12).each do |index|
      puts "Attempt #{index}"
      triedkey = input_code
      feedback = Feedback.new
      if feedback.hint(secretkey, triedkey).join == 'BBBB'
        winning_message('You')
        break
      end
      feedback.display
    end

    puts "The secret key was #{secretkey}"
  end
end

class MachineCodebreaker < UsefulMethods
  # include UsefulMethods

  def generate_sample_space
    sample_space = []
    (1..6).each do |i|
      (1..6).each do |j|
        (1..6).each do |k|
          (1..6).each do |l|
            sample_space.push(i.to_s + j.to_s + k.to_s + l.to_s)
          end
        end
      end
    end
    sample_space
  end

  def eliminate_space_algorithm(secretkey)
    sample_space = generate_sample_space
    (1..12).each do |index|
      puts "Attempt #{index}"
      triedkey = sample_space.sample
      triedkey_feedback = Feedback.new
      triedkey_pegs = triedkey_feedback.hint(secretkey, triedkey).join

      print "#{triedkey}  #{triedkey_pegs}\n"

      if triedkey_pegs == 'BBBB'
        return true
      else
        sample_space.select! do |key|
          algorithm_feedback = Feedback.new
          algorithm_pegs = algorithm_feedback.hint(triedkey, key).join
          triedkey_pegs == algorithm_pegs
        end
      end
    end
    puts "The secret key was #{secretkey}"
  end

  def play(secretkey)
    winning_message('Machine') if eliminate_space_algorithm(secretkey)
  end
end

choose = Choice.new
choose.codebreaker_or_codemaker
