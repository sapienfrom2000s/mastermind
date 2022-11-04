# frozen_string_literal: true

require_relative 'useful_methods.rb'
require_relative 'choice.rb'
require_relative 'codemaker.rb'
require_relative 'feedback.rb'
require_relative 'humancodebreaker.rb'
require_relative 'machinecodebreaker.rb'

choose = Choice.new
choose.codebreaker_or_codemaker
