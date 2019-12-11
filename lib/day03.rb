require_relative 'solver'
require_relative 'utils'

class Day03 < Solver
  def get_data
    File.readlines(file_name)
  end

  def run_one
    intersection_points.map(&method(:manhattan_distance)).min
  end

  def run_two
    intersection_points.map(&method(:signal_delay)).min
  end

  def manhattan_distance(point)
    point.map(&:abs).sum
  end

  def signal_delay(point)
    both_points.map { |points| points[point] }.sum
  end

  def intersection_points
    @intersection_points ||= both_points.map(&:keys).reduce(:&)
  end

  def both_points
    @both_points ||= data.map(&method(:parse_path))
  end

  def directions
    {
      'R' => [1, 0],
      'U' => [0, 1],
      'L' => [-1, 0],
      'D' => [0, -1],
    }
  end

  def parse_move(dir_str)
    [directions[dir_str[0]], dir_str[1..-1].to_i]
  end

  def parse_path(path)
    points = {}
    prev = [0, 0]
    signal_delay = 0
    path.split(',').each_with_index do |dir_str, idx|
      dir, num = parse_move(dir_str)
      (1..num).each do |j|
        curr = Utils.vector_add(prev, dir)
        points[curr] ||= signal_delay + j
        prev = curr
      end
      signal_delay += num
    end
    points
  end
end

