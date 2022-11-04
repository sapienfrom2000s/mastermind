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