class Node
  attr_reader :name, :parent

  def initialize(name, parent=nil)
    @name = name
    @parent = parent
  end

  def parent=(node)
    @parent = node
  end

  def is_root?
    @parent.nil?
  end

  def ancestors
    return [] if is_root?
    @ancestors ||= [@parent, *@parent.ancestors]
  end

  def number_of_ancestors
    ancestors.count
  end
end

class Tree
  attr_reader :nodes

  def initialize(edge_strings=[])
    @edge_strings = edge_strings
    @nodes = Hash.new
    build
  end

  def get_node(name)
    @nodes[name] ||= Node.new(name)
  end

  def build_edge(edge_string)
    parent, node = edge_string.split('->').map(&method(:get_node))
    node.parent = parent
  end

  def build
    @edge_strings.each(&method(:build_edge))
  end

  def common_ancestor(*nodes)
    nodes.map(&:ancestors).reduce(:&).first
  end

  def distance(*two_nodes)
    return 0 if two_nodes.uniq == two_nodes.first
    ancestor = common_ancestor(*two_nodes)
    two_nodes.map { |node| node.ancestors.index(ancestor) }.sum
  end

  def distance_by_name(*two_names)
    distance(*two_names.map(&method(:get_node)))
  end

  def children_of(node)
    nodes.select { |n| n.parent == node }
  end
end
