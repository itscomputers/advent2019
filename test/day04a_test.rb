require 'test_helper'
require_relative "../lib/day04"

class TestDay04a < MiniTest::Test
  def setup
    @test_data = '000000-999999'
    @passwords = {
      '112345' => [true, true],
      '111123' => [true, false],
      '135679' => [false, false],
      '111111' => [true, false],
      '223450' => [false, false],
      '123789' => [false, false],
      '112233' => [true, true],
      '123444' => [true, false],
      '111122' => [true, true],
    }
    @result_two = nil
    @solver = Day04.new(@test_data)
  end

  def test_result_one
    @passwords.each do |password, validity|
      assert_equal @solver.acceptable?(password, part: 1), validity.first
    end
  end

  def test_result_two
    @passwords.each do |password, validity|
        assert_equal @solver.acceptable?(password, part: 2), validity.last
    end
  end
end
