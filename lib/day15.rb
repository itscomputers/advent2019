require 'io/console'
require_relative 'solver'
require_relative 'intcode_computer'
require_relative 'utils'

class Day15 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def run_one
    droid_mover = DroidMover.new(IntcodeComputer.new(program: data))
    loop do
      puts droid_mover.print_environment
      puts "distance: #{droid_mover.distance}"
      puts ''
      puts ['north: k', 'south: j', 'east: l', 'west: h', 'release oxygen: O', 'quit: q'].join('   ')
      c = STDIN.getch
      case c
      when 'q'
        break
      when 'O'
        @oxygen_filler = OxygenFiller.new(droid_mover.environment, droid_mover.oxygen_location)
        @oxygen_filler.fill_oxygen
      else
        droid_mover.move(c)
      end
    end
    return [droid_mover.oxygen_distance, @oxygen_filler.time_elapsed]
  end

  def run_two
  end
end

class DroidMover
  attr_reader :environment, :oxygen_location, :oxygen_distance, :distance

  def initialize(computer)
    @computer = computer
    @environment = { [0, 0] => '.' }
    @position = [0, 0]
    @next_position = nil
    @oxygen_location = nil
    @distances = { [0, 0] => 0 }
  end

  def minmax(array)
    array.empty? ? [-2, 2] : Utils.vector_add(array.minmax, [-2, 2])
  end

  def x_range
    Range.new(*minmax(@environment.keys.map(&:first)))
  end

  def y_range
    Range.new(*minmax(@environment.keys.map(&:last)))
  end

  def print_environment
    y_range.map do |y|
      x_range.map do |x|
        case [x, y]
        when @position
          'D'
        when [0, 0]
          'I'
        else
          @environment[[x, y]] || ' '
        end
      end.join('')
    end
  end

  def move(chr)
    case chr
    when 'k'
      move_north
    when 'j'
      move_south
    when 'l'
      move_east
    when 'h'
      move_west
    end
    record_observation
  end

  def record_observation
    @computer.advance_to_next_output
    case @computer.output
    when 0
      @environment[@next_position] = '#'
    when 1
      unless @distances.key? @next_position
        @distances[@next_position] = distance + 1
      end
      @environment[@next_position] = '.'
      @position = @next_position
    when 2
      @environment[@next_position] = '$'
      @oxygen_distance = distance + 1
      @oxygen_location = @next_position
      @position = @next_position
    end
  end

  def distance
    @distances[@position]
  end

  def move_north
    @computer.default_input = 1
    @next_position = Utils.vector_add(@position, [0, -1])
  end

  def move_south
    @computer.default_input = 2
    @next_position = Utils.vector_add(@position, [0, 1])
  end

  def move_east
    @computer.default_input = 4
    @next_position = Utils.vector_add(@position, [1, 0])
  end

  def move_west
    @computer.default_input = 3
    @next_position = Utils.vector_add(@position, [-1, 0])
  end
end

class OxygenFiller
  attr_reader :time_elapsed

  def initialize(environment, oxygen_location)
    @environment = environment
    @unoxygenated_location_count = @environment.count { |k, v| v == '.' }
    @time_elapsed = 0
    @neighbors = [oxygen_location]
  end

  def advance_oxygen
    @neighbors = @neighbors
      .map { |pos| neighbors_of(*pos) }
      .flatten(1)
      .uniq
      .select { |pos| @environment[pos] == '.' }
    @neighbors.each do |pos|
      @environment[pos] = 'O'
      @unoxygenated_location_count -= 1
    end
    @time_elapsed += 1
  end

  def fill_oxygen
    advance_oxygen while @unoxygenated_location_count > 0
  end

  def neighbors_of(x, y)
    [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]]
  end
end

