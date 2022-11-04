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