require 'test_helper'
require_relative '../lib/day02'

class TestDay02 < MiniTest::Test
  def setup
    @day = Day02.new
    @differences = [388800, 1]
  end

  def test_arithmetic_differences
    assert_equal @day.arithmetic_differences, @differences
  end

  def test_bezout_solution
    assert_equal(
      @differences.zip(@day.bezout_solution).map { |t| t.reduce(1, :*) }.sum,
      @day.desired_output - @day.initial_output
    )
  end
end
