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
  
      if key_valid?(input)
        @secretkey = input
      else
        error_message
        enter_secretkey
      end
    end
  end