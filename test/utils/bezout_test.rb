require 'test_helper'
require_relative '../../lib/utils'
require_relative '../../lib/utils/bezout'

class TestBezout < MiniTest::Test
  def setup
    @a = rand(2..1000)
    @b = rand(2..1000)
    @d = @a.gcd(@b)
    @c = rand(2..1000) * @d
    @bezout = Bezout.new(@a, @b)
  end

  def test_primary_solution
    assert_equal Utils.vector_dot([@a, @b], @bezout.primary_solution), @d
  end

  def test_first_solution
    assert_equal Utils.vector_dot([@a, @b], @bezout.first_solution(@c)), @c
  end

  def test_lowers_and_uppers_and_solutions
    x0, y0 = @bezout.first_solution(@c)
    x_lower = 0
    y_lower = 0
    x_upper = 1000
    y_upper = 1000
    t_lower = @bezout.t_lower(@c, x0, y0, x_lower, y_upper)
    t_upper = @bezout.t_upper(@c, x0, y0, x_upper, y_lower)
    (t_lower..t_upper).each do |t|
      x, y = @bezout.solution(@c, t)
      assert_operator x_lower, :<=, x
      assert_operator x_upper, :>=, x
      assert_operator y_lower, :<=, y
      assert_operator y_upper, :>=, y
      assert_equal Utils.vector_dot([@a, @b], [x, y]), @c
      assert_includes @bezout.solutions_in_range(@c, [x_lower, x_upper], [y_lower, y_upper]), [x, y]
    end
  end
end

