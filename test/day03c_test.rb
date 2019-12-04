require 'test_helper'
require_relative "../lib/day03"

class TestDay03c < MiniTest::Test
  def setup
    @test_data = [
      'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51',
      'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7',
    ]
    @result_one = 135
    @result_two = 410
    @solver = Day03.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end

  def test_result_two
    assert_equal @solver.run_two, @result_two
  end
end
