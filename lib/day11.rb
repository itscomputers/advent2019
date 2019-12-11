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
    @direction = [0, -1]
  end

  def next_output
    @computer.advance_to_next_output
    @computer.output
  end

  def paint_panel
    @colors[@position] = next_output
  end

  def move_to_next_panel
    @direction = Utils.grid_rotate(@direction, next_output == 1 ? 'cw' : 'ccw')
    @position = Utils.vector_add(@position, @direction)
    @computer.default_input = @colors[@position] || 0
  end

  def advance
    paint_panel
    move_to_next_panel
  end

  def run
    advance until @computer.terminated
    self
  end

  def number_of_panels_painted
    @colors.keys.count
  end

  def x_range
    Range.new(*@colors.keys.map(&:first).minmax)
  end

  def y_range
    Range.new(*@colors.keys.map(&:last).minmax)
  end

  def display
    y_range.map do |y|
      x_range.map do |x|
        (@colors[[x, y]] && @colors[[x, y]] == 1) ? '#' : ' '
      end.join('')
    end
  end
end
