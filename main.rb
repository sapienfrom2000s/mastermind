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

  def winning_message(winner)
    puts "#{winner} broke the secret code"
  end

end

class Choice
  attr_accessor :codebreaker, :codemaker

  def codebreaker_or_codemaker
    puts 'Press 1 to be a codebreaker and 2 to be a codemaker!'
    input = gets.chomp

    case input
    when '1'
      @codebreaker = 'human'
      @codemaker = 'machine'
      human = HumanCodebreaker.new
      machine = Codemaker.new
      secretkey = machine.generate_secretkey
      human.play(secretkey)

    when '2'
      @codebreaker = 'machine'
      @codemaker = 'human'
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

class Codemaker
  include UsefulMethods

  attr_accessor :secretkey

  def generate_secretkey
    @secretkey = ''
    4.times { @secretkey += rand(1..6).to_s }
    @secretkey
  end

  def enter_secretkey
    puts 'Enter valid secret key'
    input = gets.chomp

    if key_valid(input)
      @secretkey = input
    else
      error_message
      enter_secretkey
    end
  end
end

class Feedback

  def hint(secretkey, triedkey)
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

    pruned_triedkey_array.each do |element|
      if index = pruned_secretkey_array.find_index(element)
        pegs.push('W')
        pruned_secretkey_array.delete_at(index)
      end
    end
    display(pegs) unless pegs.join == 'BBBB'
    pegs

  end

  def display(pegs)
    pegs.each{|peg| print peg}
    puts
  end
end

class HumanCodebreaker
  include UsefulMethods

  def input_code
    puts 'Enter your code'
    input = gets.chomp
    unless key_valid(input)
      puts 'Try again'
      input_code
    else
      input
    end
  end

  def play(secretkey)
  
    (1..12).each do |index|
      puts "Attempt #{index}"
      triedkey = input_code
      feedback = Feedback.new
      if feedback.hint(secretkey, triedkey).join == 'BBBB'
        winning_message("You")
        break
      end
    end

    puts "The secret key was #{secretkey}"
  end
end


class MachineCodebreaker
  include UsefulMethods

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

      if(triedkey_pegs == 'BBBB')
        return true
      else
        sample_space.reject! do |key|
          algorithm_feedback = Feedback.new
          algorithm_pegs = algorithm_feedback.hint(triedkey, key).join
          print "#{secretkey} #{triedkey_pegs} #{triedkey} #{algorithm_pegs} #{key}\n"
          triedkey_pegs != algorithm_pegs
        end
      end
    end
    puts "The secret key was #{secretkey}"

  end

  def play(secretkey)
    if eliminate_space_algorithm(secretkey)
      winning_message("Machine")
    end
  end
end

choose = Choice.new
choose.codebreaker_or_codemaker