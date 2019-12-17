require_relative 'solver'
require_relative 'utils'
require 'matrix'

class Day16 < Solver
  def get_data
    File.read(file_name).split('').map(&:to_i)
  end

  def run_one
    FlawedFrequencyTransmission
      .new(data)
      .after_phase(100)
      .truncate_input_signal
  end

  def run_two
    FlawedFrequencyTransmission
      .new((data * 10000).flatten)
      .reverse_after_phase(100)
      .truncate_reverse_signal
  end
end

class FlawedFrequencyTransmission
  attr_reader :input_signal, :reverse_signal

  def initialize(input_signal, base_pattern=[0, 1, 0, -1])
    @input_signal = input_signal
    @base_pattern = base_pattern
    @size = input_signal.count
  end

  def rows
    @rows ||= (1..@size).inject(Hash.new) do |hash, repeats|
      row = @base_pattern.map { |x| [x] * repeats }.flatten.cycle.take([@size, 4 * repeats].max)
      hash.merge(repeats => (row.drop(1) + row.take(1)).take(@size))
    end
  end

  def transform
    @input_signal = (1..@size).map do |i|
      Utils.vector_dot(@input_signal, rows[i]).abs % 10
    end
    self
  end

  def after_phase(k)
    k.times { transform }
    self
  end

  def truncate_input_signal
    @input_signal.take(8).join('')
  end

  def reverse_signal_size
    @size - @input_signal.take(7).join('').to_i
  end

  def get_reverse_signal
    @reverse_signal = @input_signal.reverse.take(reverse_signal_size)
  end

  def transform_reverse_signal
    @reverse_signal = @reverse_signal.inject([]) do |array, x|
      array + [((array.last || 0) + x) % 10]
    end
    self
  end

  def reverse_after_phase(k)
    get_reverse_signal
    k.times { transform_reverse_signal }
    self
  end

  def truncate_reverse_signal
    @reverse_signal.reverse.take(8).join('')
  end
end

