require_relative 'solver'
require_relative 'intcode_computer'
require_relative 'utils'
require_relative 'utils/linear_diophantine'

class Day02 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def run_one
    return IntcodeComputer.new(program: data).run.result if @data
    apply_inputs!(IntcodeComputer.new(program: data), [12, 2]).run.result.first
  end

  def run_two
    return Utils.vector_dot([100, 1], linear_diophantine_solution)
  rescue 'NotArithmeticSequences'
    (0..99).to_a.product((0..99).to_a).each do |inputs|
      if process(data, inputs).first == desired_output
        return Utils.dot_product([100, 1], *inputs)
      end
    end
  end

  def desired_output
    19690720
  end

  def initial_output
    @initial_output ||= IntcodeComputer.new(program: data).run.result.first
  end

  def apply_inputs!(intcode_computer, inputs)
    inputs.each_with_index do |input, idx|
      intcode_computer.set(idx + 1, input)
    end
    intcode_computer
  end

  def arithmetic_differences
    prevs = [initial_output, initial_output]
    differences = (1..99).map do |i|
      currs = [[i, 0], [0, i]].map do |inputs|
        apply_inputs!(IntcodeComputer.new(program: data), inputs).run.result.first
      end
      diffs = currs.zip(prevs).map { |pair| pair.first - pair.last }
      prevs = currs
      diffs
    end.uniq
    raise 'NotArithmeticSequences' unless differences.count == 1
    differences.first
  end

  def linear_diophantine_solution
    LinearDiophantine.new(
      *arithmetic_differences,
      desired_output - initial_output,
      x_range: (0..99),
      y_range: (0..99)
    ).solutions_in_range.first
  end
end
