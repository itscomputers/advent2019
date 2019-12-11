require_relative 'solver'
require_relative 'intcode_computer'
require_relative 'utils'

class Day11 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def run_one
    EmergencyShipHullPainter.new(data, 0).run.number_of_panels_painted
  end

  def run_two
    puts EmergencyShipHullPainter.new(data, 1).run.display
  end
end

class EmergencyShipHullPainter
  attr_reader :computer, :colors, :position, :direction

  def initialize(program, input)
    @computer = IntcodeComputer.new(program: program, default_input: input)
    @colors = Hash.new
    @position = [0, 0]
    @direction = [0, 1]
  end

  def next_output
    @computer.advance_to_next_output
    @computer.output
  end

  def paint
    @colors[@position] = next_output
  end

  def change_direction
    sign = (-1)**next_output
    @direction = [[0, sign * 1], [-sign * 1, 0]].map do |row|
      Utils.vector_dot(row, @direction)
    end
  end

  def move
    @position = Utils.vector_add(@position, @direction)
  end

  def get_input
    @computer.default_input = @colors[@position] || 0
  end

  def advance
    paint
    change_direction
    move
    get_input
  end

  def run
    advance until @computer.terminated
    self
  end

  def number_of_panels_painted
    @colors.keys.count
  end

  def x_range
    x0, x1 = @colors.keys.map(&:first).minmax
    (x0..x1).to_a.reverse
  end

  def y_range
    y0, y1 = @colors.keys.map(&:last).minmax
    (y0..y1).to_a.reverse
  end

  def display
    y_range.map do |y|
      x_range.map do |x|
        (@colors[[x, y]] && @colors[[x, y]] == 1) ? '#' : ' '
      end.join('')
    end
  end
end
