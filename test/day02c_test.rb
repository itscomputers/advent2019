require 'test_helper'
require_relative "../lib/day02"

class TestDay02c < MiniTest::Test
  def setup
    @test_data = [2,4,4,5,99,0]
    @result_one = [2,4,4,5,99,9801]
    @solver = Day02.new(@test_data)
  end

  def test_result_one
    assert_equal @solver.run_one, @result_one
  end
end
