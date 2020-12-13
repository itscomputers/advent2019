require_relative 'solver'
require_relative 'utils'
require 'matrix'

class Day16 < Solver
  def get_data
    File.read(file_name).chomp.split('').map(&:to_i)
  end

  def run_one
    FlawedFrequencyTransmission
      .new(data)
      .transform(100)
      .inspect
  end

  def run_two
    EnhancedFlawedFrequencyTransmission
      .new(data, 10000)
      .transform(100)
      .inspect
  end
end

class FlawedFrequencyTransmission
  attr_reader :phase

  def initialize(data, should_offset: false)
    @phase = Phase.new(data)
  end

  def transform(iterations)
    iterations.times { @phase.transform! }
    self
  end

  def inspect
    @phase.inspect
  end

  class Phase
    attr_reader :numbers

    def initialize(numbers)
      @numbers = numbers
    end

    def inspect
      @numbers.take(8).join("")
    end

    def size
      @size ||= @numbers.size
    end

    def coeffs_for(index)
      [0, 1, 0, -1].flat_map { |c| (index + 1).times.map { c } }.cycle.take(size + 1).drop(1)
    end

    def sum_for(index)
      if index > size / 2
        @numbers.drop(index).sum % 10
      else
        coeffs_for(index).zip(@numbers).sum { |(c, n)| c * n }.abs % 10
      end
    end

    def transform!
      @numbers = size.times.map { |index| sum_for index }
      self
    end
  end
end

class EnhancedFlawedFrequencyTransmission < FlawedFrequencyTransmission
  def initialize(data, multiplier)
    @offset = data.take(7).join("").to_i
    size = multiplier * data.size - @offset
    raise ArgumentError if 2*size < data.size
    @phase = Phase.new data.reverse.cycle.take(size).reverse
  end

  class Phase < FlawedFrequencyTransmission::Phase
    def transform!
      (0...size).reverse_each do |index|
        @numbers[index] = @numbers.slice(index, 2).sum % 10
      end
      self
    end
  end
end

