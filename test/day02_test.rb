require 'test_helper'
require_relative '../lib/day02'

class TestDay02 < MiniTest::Test
  def setup
    @testing = {
      [1,0,0,0,99] => [2,0,0,0,99],
      [2,3,0,3,99] => [2,3,0,6,99],
      [2,4,4,5,99,0] => [2,4,4,5,99,9801],
      [1,1,1,4,99,5,6,0,99] => [30,1,1,4,2,5,6,0,99],
      [1,9,10,3,2,3,11,0,99,30,40,50] => [3500,9,10,70,2,3,11,0,99,30,40,50],
    }
    @day = Day02.new
    @differences = [388800, 1]
  end

  def test_one
    @testing.each do |test_data, result|
      assert_equal Day02.new(test_data).run_one, result
    end
  end

  def test_arithmetic_differences
    assert_equal @day.arithmetic_differences, @differences
  end

  def test_bezout_solution
    assert_equal(
      @differences.zip(@day.linear_diophantine_solution).map { |t| t.reduce(1, :*) }.sum,
      @day.desired_output - @day.initial_output
    )
  end
end
