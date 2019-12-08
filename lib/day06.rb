require_relative 'solver'
require_relative 'utils/tree'

class Day06 < Solver
  def get_data
    File.read(file_name).split
  end

  def run_one
    Tree.new(edge_strings).nodes.values.map(&:number_of_ancestors).sum
  end

  def run_two
    return Tree.new(edge_strings).distance_by_name('L', 'D') if @test_data
    Tree.new(edge_strings).distance_by_name('YOU', 'SAN')
  end

  def edge_strings
    data.map { |orbit_string| orbit_string.gsub(')', '->') }
  end
end

