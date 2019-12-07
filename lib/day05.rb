require_relative 'solver'
require_relative 'intcode_computer'

class Day05 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def run_one
    IntcodeComputer.new(program: data, input: 1).run.output.last
  end

  def run_two
    IntcodeComputer.new(program: data, input: 5).run.output.last
  end

  def run_program(input)
    IntcodeComputer.new(program: data, input: input).run.output.last
  end
end

