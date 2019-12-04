require 'test_helper'
require_relative '../../lib/utils'
require_relative '../../lib/utils/linear_diophantine'

class TestLinearDiophantine < MiniTest::Test
  def setup
    @a = rand(2..1000)
    @b = rand(2..1000)
    @d = @a.gcd(@b)
    @c = rand(2..1000) * @d
    @linear_diophantine = LinearDiophantine.new(@a, @b, @c, x_range: (0..1000), y_range: (0..1000))
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
      assert_operator x_lower, :<=, x
      assert_operator x_upper, :>=, x
      assert_operator y_lower, :<=, y
      assert_operator y_upper, :>=, y
      assert_equal Utils.vector_dot([@a, @b], [x, y]), @c
      assert_includes @bezout.solutions_in_range, [x, y]
    end
  end
end

