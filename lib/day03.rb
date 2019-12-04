require_relative 'solver'

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
    @both_points ||= build_points
  end

  def build_points
    data.map(&method(:parse_path))
  end

  def parse_move(dir_str)
    {
      :dir => {
        'R' => [1, 0],
        'U' => [0, 1],
        'L' => [-1, 0],
        'D' => [0, -1],
      }[dir_str[0]],
      :num => dir_str[1..-1].to_i
    }
  end

  def parse_path(path)
    points = {}
    prev = [0, 0]
    signal_delay = 0
    path.split(',').each_with_index do |dir_str, idx|
      dir, num = parse_move(dir_str).values
      (1..num).each do |j|
        curr = add_points(prev, dir)
        points[curr] ||= signal_delay + j
        prev = curr
      end
      signal_delay += num
    end
    points
  end

  def add_points(u, v)
    u.zip(v).map(&:sum)
  end
end
