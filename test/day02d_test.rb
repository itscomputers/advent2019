require 'test_helper'
require_relative "../lib/day02"

class TestDay02d < MiniTest::Test
  def setup
    @test_data = [1,1,1,4,99,5,6,0,99]
    @result_one = [30,1,1,4,2,5,6,0,99]
    @solver = Day02.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end
end
