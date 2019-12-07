require 'test_helper'
require_relative "../lib/day05"
require_relative "../lib/intcode_computer"

class TestDay05 < MiniTest::Test
  def test_case_1
    day = Day05.new([3,9,8,9,10,9,4,9,99,-1,8])
    [[8, 1], [7, 0]].each do |pair|
      assert_equal day.run_program(pair.first), pair.last
    end
  end

  def test_case_2
    day = Day05.new([3,9,7,9,10,9,4,9,99,-1,8])
    [[7, 1], [8, 0], [9, 0]].each do |pair|
      assert_equal day.run_program(pair.first), pair.last
    end
  end

  def test_case_3
    day = Day05.new([3,3,1108,-1,8,3,4,3,99])
    [[8, 1], [7, 0]].each do |pair|
      assert_equal day.run_program(pair.first), pair.last
    end
  end

  def test_case_4
    day = Day05.new([3,3,1107,-1,8,3,4,3,99])
    [[7, 1], [8, 0], [9, 0]].each do |pair|
      assert_equal day.run_program(pair.first), pair.last
    end
  end

  def test_case_5
    day = Day05.new([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9])
    [[0, 0], [2, 1]].each do |pair|
      assert_equal day.run_program(pair.first), pair.last
    end
  end

  def test_case_6
    day = Day05.new([3,3,1105,-1,9,1101,0,0,12,4,12,99,1])
    [[0, 0], [2, 1]].each do |pair|
      assert_equal day.run_program(pair.first), pair.last
    end
  end

  def test_case_7
    day = Day05.new([
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
    ])
    assert_equal day.run_program(7), 999
  end
end

