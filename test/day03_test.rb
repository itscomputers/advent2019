require 'test_helper'
require_relative "../lib/day03"

class TestDay03a < MiniTest::Test
  def setup
    @testing = {
      [
        'R8,U5,L5,D3',
        'U7,R6,D4,L4'
      ] => [6, 30],
      [
        'R75,D30,R83,U83,L12,D49,R71,U7,L72',
        'U62,R66,U55,R34,D71,R55,D58,R83',
      ] => [159, 610],
      [
        'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51',
        'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7',
      ] => [135, 410],
    }
  end

  def test_result_one
    @testing.each do |test_data, results|
      assert_equal Day03.new(test_data).run_one, results.first
    end
  end

  def test_result_two
    @testing.each do |test_data, results|
      assert_equal Day03.new(test_data).run_two, results.last
    end
  end
end
