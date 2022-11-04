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
      algorithm_feedback = Feedback.new
      
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