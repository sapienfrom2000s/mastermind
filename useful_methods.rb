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