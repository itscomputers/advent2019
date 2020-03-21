require 'test_helper'
require_relative "../lib/day17"

class TestDay17 < MiniTest::Test
  def setup
    @testing = {}
  end

  def test_result_one
    @testing.each do |test_data, results|
      assert_equal Day17.new(test_data).run_one, results.first
    end
  end

  def test_result_two
    @testing.each do |test_data, results|
      assert_equal Day17.new(test_data).run_two, results.last
    end
  end
end
