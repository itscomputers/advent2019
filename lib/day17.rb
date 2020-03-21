require_relative 'solver'
require_relative 'utils'
require_relative 'intcode_computer'

class Day17 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def run_one
    ascii.alignment_parameters_sum
  end

  def run_two
    IntcodeComputer.run(program: [2] + data.drop(1)).output
  end

  def ascii
    @ascii ||= ASCII.new(data)
  end

  def movement_instructions
    @instructions ||= ScaffoldVisitor.new(
      ascii.scaffold,
      ascii.initial_position,
      ascii.initial_direction,
    ).movement_instructions
  end

  def inputs
    @inputs ||= MovementBuilder.new(movement_instructions).movement
  end
end

class ASCII
  def initialize(program)
    @program = program
  end

  def computer
    @computer ||= IntcodeComputer.new(program: @program)
  end

  def view
    @view ||= computer.run.outputs.map(&:chr)
  end

  def print_view
    puts view.join('')
  end

  def lines
    view.join('').split
  end

  def grid
    return @grid if @grid
    @grid = Hash.new
    lines.each_with_index do |line, y|
      line.split('').each_with_index do |chr, x|
        @grid[[x, y]] = chr
      end
    end
    @grid
  end

  def scaffold
    @scaffold ||= grid.keys.select { |k| grid[k] == '#' }
  end

  def initial_position
    grid.keys.select { |k| %w(< ^ > v).include? grid[k] }.first
  end

  def initial_direction
    {
      '<' => [-1, 0],
      '^' => [0, -1],
      '>' => [1, 0],
      'v' => [0, 1],
    }[grid[initial_position]]
  end

  def scaffold_intersections
    @intersections ||= scaffold.select { |point| (neighbors(*point) & scaffold).count == 4 }
  end

  def alignment_parameters_sum
    scaffold_intersections.map { |(x, y)| x * y }.sum
  end
end

class ScaffoldVisitor
  attr_reader :movement_instructions

  def initialize(scaffold, initial_position, initial_direction)
    @scaffold = scaffold
    @position = initial_position
    @direction = initial_direction
    @movement_instructions = []
    @end_of_path = false
  end

  def forward_one
    Utils.vector_add(@position, @direction)
  end

  def can_move_forward_one?
    @scaffold.include? forward_one
  end

  def move_forward_one
    @position = forward_one
  end

  def detect_distance_and_move
    distance = 0
    loop do
      if can_move_forward_one?
        move_forward_one
        distance += 1
      else
        break
      end
    end
    @movement_instructions << distance if distance > 0
  end

  def left_turn
    Utils.grid_rotate(@direction, 'ccw')
  end

  def right_turn
    Utils.grid_rotate(@direction, 'cw')
  end

  def can_turn_left?
    @scaffold.include? Utils.vector_add(@position, left_turn)
  end

  def can_turn_right?
    @scaffold.include? Utils.vector_add(@position, right_turn)
  end

  def turn_left
    @movement_instructions << 'L'
    @direction = left_turn
  end

  def turn_right
    @movement_instructions << 'R'
    @direction = right_turn
  end

  def detect_direction_and_turn
    if can_turn_left?
      turn_left
    elsif can_turn_right?
      turn_right
    else
      @end_of_path = true
    end
  end

  def movement_instructions
    return @movement_instructions unless @movement_instructions.empty?
    until @end_of_path
      detect_direction_and_turn
      detect_distance_and_move
    end
    @movement_instructions
  end
end

class MovementBuilder
  attr_reader :instructions, :partition

  def initialize(instructions)
    @instructions = instructions
  end

  def main_routine
    insert_commas_and_return(%w(A A B A C B).map(&:ord))
  end

  def movement_functions
    [
      @instructions.slice(0, 14),
      @instructions.slice(28, 8),
      @instructions.slice(50, 14),
    ].map do |instructions|
      insert_commas_and_return(instructions.map(&:to_s).map(&:ord))
    end
  end

  def insert_commas_and_return(array)
    new_array = array.inject([]) do |arr, val|
      (arr + [val, 44]).flatten
    end
    new_array[0...-1] + [10]
  end

  def movement
    main_routine + movement_functions.flatten
  end
end

def neighbors(x, y)
  [[x + 1, y], [x - 1, y], [x, y - 1], [x, y + 1]]
end

