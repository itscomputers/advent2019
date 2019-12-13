require_relative 'solver'
require_relative 'utils'

class Day12 < Solver
  def get_data
    File.readlines(file_name)
  end

  def run_one
    total_energy_after(1000)
  end

  def run_two
    steps_until_repeat
  end

  def parse_position(line)
    line.match(/x=(\-?\d+), y=(\-?\d+), z=(\-?\d+)/)[1..3].map(&:to_i)
  end

  def initial_positions
    data.map(&method(:parse_position)).transpose
  end

  def total_energy_after(k)
    gravitons = initial_positions.map { |positions| Graviton.new(positions) }
    k.times { gravitons.map(&:advance) }
    positions = gravitons.map(&:positions).transpose
    velocities = gravitons.map(&:velocities).transpose
    positions.zip(velocities).map { |(p, v)| p.map(&:abs).sum * v.map(&:abs).sum }.sum
  end

  def steps_until_repeat
    initial_positions
      .map { |numbers| Graviton.new(numbers) }
      .map(&:find_repeat)
      .reduce(&:lcm)
  end
end

class Graviton
  attr_reader :positions, :velocities

  def initialize(initial_positions)
    @initial_positions = initial_positions
    @positions = initial_positions.map(&:dup)
    @step = 1
    @velocities = [0, 0, 0, 0]
  end

  def update_velocities
    @velocities = Utils.vector_add(
      @velocities,
      @positions.map do |number|
        above = @positions.count { |x| x > number }
        below = @positions.count { |x| x < number }
        above - below
      end
    )
  end

  def update_positions
    @positions =  Utils.vector_add(@positions, @velocities)
  end

  def advance
    @step += 1
    update_velocities
    update_positions
  end

  def find_repeat
    advance
    advance until @positions == @initial_positions
    @step
  end
end

