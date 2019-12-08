require_relative '../../lib/utils/tree'

class TestNode < MiniTest::Test
  PICTURE = "root
            /    \
           a      c
          /
         b"

  def setup
    @root = Node.new('root')
    @node_a = Node.new('a', @root)
    @node_b = Node.new('b', @node_a)
    @node_c = Node.new('c', @root)
  end

  def test_can_set_parent
    assert_equal @node_a.parent, @root
    @node_a.parent = @node_c
    assert_equal @node_a.parent, @node_c
    @node_a.parent = @root
    assert_equal @node_a.parent, @root
  end

  def test_is_root
    assert @root.is_root?
    [@node_a, @node_b, @node_b].each do |node|
      refute node.is_root?
    end
  end

  def test_ancestors
    assert_equal @root.ancestors, []
    [@node_a, @node_c].each do |node|
      assert_equal node.ancestors, [@root]
    end
    assert_equal @node_b.ancestors, [@node_a, @root]
  end
end

class TestTree < MiniTest::Test
  PICTURE = "root -- a -- b -- c
            /       / \    \
           d       e   f    g -- h"

  def setup
    @edge_strings = %w(root->d root->a a->e a->f a->b b->g b->c g->h)
    @tree = Tree.new(@edge_strings)
  end

  def test_build
    assert_equal @tree.nodes.keys.sort, %w(root a b c d e f g h).sort
    %w(a d).each { |name| assert_equal @tree.nodes[name].parent, @tree.nodes['root'] }
    %w(b e f).each { |name| assert_equal @tree.nodes[name].parent, @tree.nodes['a'] }
    %w(c g).each { |name| assert_equal @tree.nodes[name].parent, @tree.nodes['b'] }
    assert_equal @tree.nodes['h'].parent, @tree.nodes['g']
  end

  def test_common_ancestor
    root, a, b, c, d, e, f, g, h = %w(root a b c d e f g h).map { |name| @tree.nodes[name] }
    assert_equal @tree.common_ancestor(e, g), a
    assert_equal @tree.common_ancestor(c, h), b
    assert_equal @tree.common_ancestor(e, f), a
    assert_equal @tree.common_ancestor(c, e, g), a
    assert_equal @tree.common_ancestor(d, e, g), root
    assert_equal @tree.common_ancestor(d, e, f, g, c, h), root
  end

  def distance
    root, a, b, c, d, e, f, g, h = %w(root a b c d e f g h).map { |name| @tree.nodes[name] }
    [a, b, c, d, e, f, g, h].each do |node|
      assert_equal @tree.distance(node, root), node.ancestors.count - 1
      assert_equal @tree.distance(node, node), 0
    end
    [a, b, c, e, f, g, h].each do |node|
      assert_equal @tree.distance(node, d), node.ancestors.count
    end
    assert_equal @tree.distance(e, f), 2
    assert_equal @tree.distance(e, c), 3
    assert_equal @tree.distance(e, h), 4
  end

  def children
    a, b, c, e, f, g = %w(a b c e f g).map { |name| @tree.nodes[name] }
    assert_equal @tree.children_of(a).sort, [b, e, f].sort
    assert_equal @tree.children_of(b).sort, [c, g].sort
    assert_equal @tree.children_of(c), []
  end

  def test_get_and_set_node
    tree = Tree.new
    name = 'new node'
    refute tree.nodes.key? name
    node = tree.get_node(name)
    assert_equal node.class, Node
    assert tree.nodes.key? name
    assert_equal tree.get_node(name), node
  end

  def test_build_edge
    tree = Tree.new
    tree.build_edge('a->b')
    %w(a b).each { |name| assert tree.nodes.key? name }
    assert_equal tree.nodes['b'].parent, tree.nodes['a']
    tree.build_edge('a->c')
    assert tree.nodes.key? 'c'
    assert_equal tree.nodes['c'].parent, tree.nodes['a']
  end
end

