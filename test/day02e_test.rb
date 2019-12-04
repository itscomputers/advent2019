require 'test_helper'
require_relative "../lib/day02"

class TestDay02e < MiniTest::Test
  def setup
    @test_data = [1,9,10,3,2,3,11,0,99,30,40,50]
    @result_one = [3500,9,10,70,2,3,11,0,99,30,40,50]
    @solver = Day02.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end
end
