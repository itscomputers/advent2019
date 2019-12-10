require 'test_helper'
require_relative "../lib/day09"

class TestDay09 < MiniTest::Test

  def test_case_2
    test_data = [1102,34915192,34915192,7,4,7,99,0]
    assert_equal Day09.new(test_data).run_one.to_s.length, 16
  end

  def test_case_3
    test_data = [104,1125899906842624,99]
    assert_equal Day09.new(test_data).run_one, test_data[1]
  end
end
