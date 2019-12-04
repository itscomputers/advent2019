require 'test_helper'
require_relative "../lib/day03"

class TestDay03a < MiniTest::Test
  def setup
    @test_data = ['R8,U5,L5,D3', 'U7,R6,D4,L4']
    @result_one = 6
    @result_two = 30
    @solver = Day03.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end

  def test_result_two
    assert_equal @solver.run_two, @result_two
  end
end
