require_relative 'solver'
require_relative 'utils/bezout'

class Day02 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def op
    {
      1 => lambda { |inputs| inputs.reduce(0, :+) },
      2 => lambda { |inputs| inputs.reduce(1, :*) }
    }
  end

  def process_instruction(program, pointer, length=4)
    op_id, *input_pointers, output_pointer = program[pointer...pointer+length]
    program[output_pointer] = op[op_id].call(input_pointers.map { |p| program[p] })
  end

  def apply_inputs(program, inputs)
    [program.first, *inputs] + program[inputs.count+1..-1]
  end

  def process(program, inputs=nil, length=4)
    program = apply_inputs(program, inputs) if inputs
    pointer = 0

    while program[pointer] != 99
      process_instruction(program, pointer, length)
      pointer += length
    end

    program
  end

  def run_one
    return process(@data) if @data
    process(data, [12, 2]).first
  end

  def run_two
    noun, verb = bezout_solution
    return 100 * noun + verb
  rescue 'NotArithmeticSequences'
    (0..99).to_a.product((0..99).to_a).each do |inputs|
      if process(data, inputs).first == desired_output
        return inputs.zip([100, 1]).map { |t| t.reduce(1, :*) }.sum
      end
    end
    100 * noun + verb
  end

  def desired_output
    19690720
  end

  def initial_output
    @initial_output ||= process(data).first
  end

  def arithmetic_differences
    return @arithmetic_differences if @arithmetic_differences
    prevs = [initial_output, initial_output]
    differences = (1..99).map do |i|
      currs = [process(data, [i, 0]).first, process(data, [0, i]).first]
      diffs = currs.zip(prevs).map { |pair| pair.first - pair.last }
      prevs = currs
      diffs
    end.uniq
    raise 'NotArithmeticSequences' unless differences.count == 1
    @arithmetic_differences = differences.first
  end

  def bezout_solution
    Bezout
      .new(*arithmetic_differences)
      .solutions_in_range(desired_output - initial_output, [0, 99], [0, 99]).first
  end
end
