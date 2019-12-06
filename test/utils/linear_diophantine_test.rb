require 'test_helper'
require_relative '../../lib/utils'
require_relative '../../lib/utils/linear_diophantine'

class TestLinearDiophantine < MiniTest::Test
  def setup
    @a = rand(2..1000)
    @b = rand(2..1000)
    @d = @a.gcd(@b)
    @c = rand(2..1000) * @d
    @x_range = (0..1000)
    @y_range = (0..1000)
    @linear_diophantine = LinearDiophantine.new(@a, @b, @c, x_range: @x_range, y_range: @y_range)
  end

  def test_primary_solution
    assert_equal Utils.vector_dot([@a, @b], @linear_diophantine.bezout), @d
  end

  def test_first_solution
    assert_equal Utils.vector_dot([@a, @b], @linear_diophantine.first_solution), @c
  end

  def test_lowers_and_uppers_and_solutions
    t_lower = @linear_diophantine.t_lower
    t_upper = @linear_diophantine.t_upper
    (t_lower..t_upper).each do |t|
      x, y = @linear_diophantine.solution(t)
      assert_operator @x_range.first, :<=, x
      assert_operator @x_range.last, :>=, x
      assert_operator @y_range.first, :<=, y
      assert_operator @y_range.last, :>=, y
      assert_equal Utils.vector_dot([@a, @b], [x, y]), @c
      assert_includes @bezout.solutions_in_range, [x, y]
    end
  end
end

