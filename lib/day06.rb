require_relative 'solver'
require_relative 'utils/tree'

class Day06 < Solver
  def get_data
    File.read(file_name).split
  end

  def tree
    @tree ||= Tree.new(data, edge_separator=')')
  end

  def names
    @test_data ? %w(L D) : %w(YOU SAN)
  end

  def run_one
    tree.nodes.values.map(&:number_of_ancestors).sum
  end

  def run_two
    tree.distance_by_name(*names)
  end
end

