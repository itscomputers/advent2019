require 'test_helper'
require_relative "../lib/day16"

class TestFlawedFrequencyTransmission < MiniTest::Test
  def test_case_1
    fft = FlawedFrequencyTransmission.new([1,2,3,4,5,6,7,8])
    assert_equal fft.input_signal, [1,2,3,4,5,6,7,8]
    assert_equal fft.transform.input_signal, [4,8,2,2,6,1,5,8]
    assert_equal fft.transform.input_signal, [3,4,0,4,0,4,3,8]
    assert_equal fft.transform.input_signal, [0,3,4,1,5,5,1,8]
    assert_equal fft.transform.input_signal, [0,1,0,2,9,4,9,8]
  end

  def test_run_one
    [
      {
        :test_data => [8,0,8,7,1,2,2,4,5,8,5,9,1,4,5,4,6,6,1,9,0,8,3,2,1,8,6,4,5,5,9,5],
        :result => '24176176',
      },
      {
        :test_data => [1,9,6,1,7,8,0,4,2,0,7,2,0,2,2,0,9,1,4,4,9,1,6,0,4,4,1,8,9,9,1,7],
        :result => '73745418',
      },
      {
        :test_data => [6,9,3,1,7,1,6,3,4,9,2,9,4,8,6,0,6,3,3,5,9,9,5,9,2,4,3,1,9,8,7,3],
        :result => '52432133',
      },
    ].each do |test|
      assert_equal Day16.new(test[:test_data]).run_one, test[:result]
    end
  end

  def test_run_two
    test = {
      :test_data => [0,3,0,8,1,7,7,0,8,8,4,9,2,1,9,5,9,7,3,1,1,6,5,4,4,6,8,5,0,5,1,7],
      :result => '53553731',
    }
    assert_equal Day16.new(test[:test_data]).run_two, test[:result]
  end
end
