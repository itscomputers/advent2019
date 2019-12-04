require 'test_helper'
require_relative "../lib/day03"

class TestDay03b < MiniTest::Test
  def setup
    @test_data = [
      'R75,D30,R83,U83,L12,D49,R71,U7,L72',
      'U62,R66,U55,R34,D71,R55,D58,R83',
    ]
    @result_one = 159
    @result_two = 610
    @solver = Day03.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end

  def test_result_two
    assert_equal @solver.run_two, @result_two
  end
end
