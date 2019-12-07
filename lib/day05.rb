require_relative 'solver'
require_relative 'intcode_computer'

class Day05 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def run_one
    run_program(input: 1)
  end

  def run_two
    run_program(input: 5)
  end

  def run_program(input:)
    IntcodeComputer.run(program: data, inputs: [input]).output
  end
end

