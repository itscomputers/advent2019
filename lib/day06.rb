require_relative 'solver'
require_relative 'utils/tree'

class Day06 < Solver
  def get_data
    File.read(file_name).split
  end

  def run_one
    Tree.new(data, edge_separator=')').nodes.values.map(&:number_of_ancestors).sum
  end

  def run_two
    return Tree.new(data, edge_separator=')').distance_by_name('L', 'D') if @test_data
    Tree.new(data, edge_separator=')').distance_by_name('YOU', 'SAN')
  end
end

