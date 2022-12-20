class Feedback
  FEEDBACK_STRING_MAX_INDEX = 3

  def hint(secretkey, triedkey)
    @secretkey = secretkey.split('')
    @triedkey = triedkey.split('')
    pegs = (black_pegs + \
            white_pegs).join
  end

  # '*','?' is used as a trick so that each count is unique
  def black_pegs
    pegs = []
    0.upto(FEEDBACK_STRING_MAX_INDEX) do |index|
      next unless @secretkey[index] == @triedkey[index]

      pegs.push('B')
      @secretkey[index] = '*'
      @triedkey[index] = '?'
    end
    pegs
  end

  def white_pegs
    pegs = []
    @triedkey.each do |element|
      if index = @secretkey.find_index(element)
        pegs.push('W')
        @secretkey[index] = '*'
      end
    end
    pegs
  end

  def display
    pegs.each { |peg| print peg }
    puts
  end
end
