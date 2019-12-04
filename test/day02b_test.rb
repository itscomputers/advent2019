require 'test_helper'
require_relative "../lib/day02"

class TestDay02b < MiniTest::Test
  def setup
    @test_data = [2,3,0,3,99]
    @result_one = [2,3,0,6,99]
    @solver = Day02.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end
end
