require_relative 'solver'

class Day18 < Solver
  def get_data
  end

  def run_one
  end

  def run_two
  end
end

class TritonUnderground
  attr_reader :position, :nodes, :keys, :doors

  def initialize(data)
    @data = data
    @position = nil
    @keys = Hash.new
    @doors = Hash.new
  end

  def present
    @nodes.map { |(pos, node)| [pos, node.present] }.to_h
  end

  def nodes
    return @nodes unless @nodes.nil?
    @nodes = Hash.new
    @data.each_with_index do |row, y|
      row.split('').each_with_index do |label, x|
        next if label == '#'
        node = TritonNode.new(label)
        @nodes[[x, y]] = node
        @keys[node.label] = node if node.is_key?
        @doors[node.label] = node if node.is_door?
        [[x - 1, y], [x, y - 1]].select { |pos| @nodes.key? pos }.each do |pos|
          @nodes[pos].add_neighbor(node)
          node.add_neighbor(@nodes[pos])
        end
      end
    end
    @nodes
  end
end

class TritonNode
  attr_reader :label, :connections, :neighbors

  def initialize(label)
    @label = label.sub('@', '.')
    @neighbors = []
  end

  def present
    {
      label: @label,
      connections: @connections.reject do |node, distance|
        node.empty?
      end.map do |node, distance|
        [node.label, distance]
      end.to_h
    }
  end

  def add_neighbor(node)
    @neighbors << node
  end

  def paths
    return @paths unless @paths.nil?
    @visited = { self => 0 }
    @paths = Hash.new
    terminated_paths = []
    open = @neighbors.map { |n| [self, n] }
    loop do

      open, new_terminated = open.partition { |path| path.last.empty? }
      terminated += new_terminated

      open.map do |path|
        path.last.neighbors.

      paths = paths.map do |path|
        path.last.neighbors.map { |n| path + [n] }
      end.flatten(1)
    end
    @paths
  end

  def empty?
    @label == '.'
  end

  def is_key?
    ('a'..'z') === label
  end

  def is_door?
    ('A'..'Z') === label
  end

  def label=(label)
    @label = label
  end
end

