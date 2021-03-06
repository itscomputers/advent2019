require_relative 'solver'
require_relative 'intcode_computer'

class Day07 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def run_one
    (0..4).to_a.permutation(5).map(&method(:from_sequence)).max
  end

  def run_two
    (5..9).to_a.permutation(5).map(&method(:from_sequence_with_feedback)).max
  end

  def from_sequence(inputs)
    inputs.inject(0) do |default_input, input|
      IntcodeComputer.run(
        program: data,
        inputs: [input],
        default_input: default_input
      ).output
    end
  end

  def from_sequence_with_feedback(inputs)
    default_input = 0
    computers = inputs.map do |s|
      IntcodeComputer.new(program: data, inputs: [s], default_input: default_input)
    end

    idx = 0
    until computers.map(&:terminated).all?
      computer = computers[idx % 5]
      computer.default_input = default_input
      default_input = computer.advance_to_next_output.output
      idx = idx + 1
    end
    default_input
  end
end
