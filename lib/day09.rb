require_relative 'solver'
require_relative 'intcode_computer'

class Day09 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def run_one
    IntcodeComputer.run(program: data, inputs: [1]).output
  end

  def run_two
    IntcodeComputer.run(program: data, inputs: [2]).output
  end
end

