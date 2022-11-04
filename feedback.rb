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