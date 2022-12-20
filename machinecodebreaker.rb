class MachineCodebreaker
  include UsefulMethods
  attr_reader :sample_space

  MAX_ATTEMPTS = 12

  def generate_sample_space
   @sample_space = [*1..6].repeated_permutation(4).map{|i_j_k_l| i_j_k_l.join}
  end

  def eliminate_space_algorithm(secretkey)
    generate_sample_space
    algorithm_feedback = Feedback.new

    1.upto MAX_ATTEMPTS do |index|
      puts "Attempt #{index}"
      triedkey = sample_space.sample
      triedkey_feedback = Feedback.new
      triedkey_pegs = triedkey_feedback.hint(secretkey, triedkey)

      print "#{triedkey}  #{triedkey_pegs}\n"

      return true if triedkey_pegs == 'BBBB'

      prune_sample_space(algorithm_feedback, triedkey_pegs, triedkey)

    end
    puts "The secret key was #{secretkey}"
  end

  def prune_sample_space(algorithm_feedback, triedkey_pegs, triedkey)

    @sample_space.select! do |key|
      algorithm_pegs = algorithm_feedback.hint(triedkey, key)
      triedkey_pegs == algorithm_pegs
    end

  end

  def play(secretkey)
    winning_message('Machine') if eliminate_space_algorithm(secretkey)
  end
end
