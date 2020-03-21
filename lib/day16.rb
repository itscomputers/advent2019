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
      .new(data)
      .truncated_offset_after_phase_100
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

  def offset
    @offset ||= @input_signal.take(7).join('').to_i
  end

  def offset_size
    @offset_size ||= 10000 * @size - offset
  end

  def offset_signal
    @offset_signal ||= @input_signal.reverse.cycle.take(offset_size).reverse
  end

  def apply(value, index, row)
    row[index] ? value * row[index] % 10 : 0
  end

  def first_five_entries(row)
    (1..7).map do |x|
      x * 4
    end.map do |i|
      apply(5, i, row)
    end.sum % 10
  end

  def five_entries(row)
    (row.count / 128).times.map do |j|
      (0..7).map do |i|
        128*(j + 1) + 4*i
      end
    end.flatten.map do |i|
      apply(5, i, row)
    end.sum % 10
  end

  def four_entries(row)
    (row.count/ 400).times.map do |j|
      (1..3).map do |i|
        -100 + 500*j + 125*i
      end
    end.flatten.map do |i|
      apply(4, i, row)
    end.sum % 10
  end

  def nine_entries(row)
    (row.count / 400).times.map do |j|
      400 + 500*j
    end.map do |i|
      apply(9, i, row)
    end.sum % 10
  end

  def entry_row(i)
    row = offset_signal.drop(i)
    (row.first + first_five_entries(row) + five_entries(row) + four_entries(row) + nine_entries(row)) % 10
  end

  def offset_transform(i)
    (0..7).map { |i| entry_row(i) }.join('')
  end

  def truncated_offset_after_phase_100
    8.times.map do |i|
      entry_row(i)
    end.join('')
  end
end

