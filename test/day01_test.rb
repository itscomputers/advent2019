require 'test_helper'
require_relative "../lib/day01"

class TestDay01 < MiniTest::Test
  def setup
    @testing = {
      [12] => [2, 2],
      [14] => [2, 2],
      [1969] => [654, 966],
      [100756] => [33583, 50346]
    }
  end

  def test_result_one
    @testing.each do |test_data, results|
      assert_equal Day01.new(test_data).run_one, results.first
    end
  end

  def test_result_two
    @testing.each do |test_data, results|
      assert_equal Day01.new(test_data).run_two, results.last
    end
  end
end
