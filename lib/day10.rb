require_relative 'solver'
require_relative 'utils'

class Day10 < Solver
  def get_data
    File.read(file_name).split
  end

  def coords
    @coords ||= data.map.with_index do |row, y|
      row.split('').map.with_index do |s, x|
        [x, y] if s == '#'
      end
    end.flatten(1).compact
  end

  def asteroid_monitor
    @asteroid_monitor ||= AsteroidMonitor.new(coordinates: coords, limit: 200)
  end

  def run_one
    asteroid_monitor.maximum_visible
  end

  def run_two
    while @asteroid_monitor.can_vaporize_group?
      @asteroid_monitor = @asteroid_monitor.vaporize_and_advance
    end
    Utils.vector_dot(@asteroid_monitor.last_remaining, [100, 1])
  end
end

class AsteroidMonitor
  attr_reader :center

  def initialize(coordinates:, center: nil, limit: nil)
    @coordinates = coordinates
    @center = center
    @limit = limit
    @group_by_slope = nil
    get_group_by_slope
    get_center unless center
  end

  def slope(point, other)
    other.zip(point).map { |pair| pair.reduce(:-) }
  end

  def reduced_slope(point, other)
    original_slope = slope(point, other)
    gcd = original_slope.reduce(:gcd)
    original_slope.map { |coordinate| coordinate / gcd }
  end

  def slope_as_float(point, other)
    slope(point, other).reverse.map(&:to_f).reduce(:/)
  end

  def distance(point, other)
    slope(point, other).map(&:abs).sum
  end

  def coordinate_pairs
    @center ?
      @coordinates.reject { |point| point == @center}.map { |point| [@center, point] } :
      @coordinates.combination(2)
  end

  def get_group_by_slope
    result = Hash.new { |hash, key| hash[key] = Hash.new { |h, k| h[k] = [] } }
    coordinate_pairs.map do |coord_pair|
      m = reduced_slope(*coord_pair)
      result[coord_pair.first][m] << coord_pair.last
      result[coord_pair.last][m.map { |t| -t }] << coord_pair.first
    end
    @group_by_slope = result
  end

  def get_center
    @center = @group_by_slope.keys.max_by { |m| @group_by_slope[m].count }
  end

  def maximum_visible
    @group_by_slope[@center].count
  end

  def visible
    @group_by_slope[@center].values.map do |points|
      points.min_by { |point| distance(@center, point) }
    end
  end

  def ordered_visible
    visible.map do |point|
      [(slope(@center, point).first < 0) && 1 || 0, slope_as_float(@center, point), *point]
    end.sort.map { |t| t[2..3] }
  end

  def can_vaporize_group?
    @limit.nil? || (visible.count < @limit)
  end

  def vaporize_and_advance
    return self unless can_vaporize_group?
    self.new(coordinates: @coordinates - visible, center: @center, limit: @limit - visible.count)
  end

  def last_remaining
    !can_vaporize_group? && ordered_visible[@limit - 1]
  end
end

