require 'test_helper'
require_relative '../lib/intcode_computer'

class TestIntcodeComputer < MiniTest::Test
  def computer(d, i=nil)
    IntcodeComputer.new(program: d, inputs: i)
  end

  def test_set_and_get
    c = computer([5, 4, 3, 2, 1], [666])
    refute_equal c.result[2], 1000
    refute_equal c.get(2), 1000
    c.set(2, 1000)
    assert_equal c.result[2], 1000
    assert_equal c.get(2), 1000
  end

  def test_one
    c = computer([1, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_params, [3, 5, 4]
    c.advance
    assert_equal c.get(4), 3 + 5
    assert_equal c.pointer, 4
  end

  def test_two
    c = computer([2, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_params, [3, 5, 4]
    c.advance
    assert_equal c.get(4), 3 * 5
    assert_equal c.pointer, 4
  end

  def test_three
    c = computer([3, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5]
    assert_equal c.instruction_params, [5]
    refute_equal c.get(5), 666
    c.advance
    assert_equal c.get(5), 666
    assert_equal c.pointer, 2
  end

  def test_four
    c = computer([4, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5]
    assert_equal c.instruction_params, [3]
    assert_nil c.output
    c.advance
    assert_equal c.output, 3
    assert_equal c.pointer, 2
  end

  def test_five_with_nonzero
    c = computer([5, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1]
    assert_equal c.instruction_params, [3, 5]
    c.advance
    assert_equal c.pointer, 5
  end

  def test_five_with_zero
    c = computer([5, 5, 1, 4, 2, 0], [666])
    assert_equal c.instruction_raw_params, [5, 1]
    assert_equal c.instruction_params, [0, 5]
    c.advance
    assert_equal c.pointer, 3
  end

  def test_six_with_nonzero
    c = computer([6, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1]
    assert_equal c.instruction_params, [3, 5]
    c.advance
    assert_equal c.pointer, 3
  end

  def test_six_with_zero
    c = computer([6, 5, 1, 4, 2, 0], [666])
    assert_equal c.instruction_raw_params, [5, 1]
    assert_equal c.instruction_params, [0, 5]
    c.advance
    assert_equal c.pointer, 5
  end

  def test_seven_with_less_than
    c = computer([7, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_params, [3, 5, 4]
    c.advance
    assert_equal c.get(4), 1
    assert_equal c.pointer, 4
  end

  def test_seven_with_more_than
    c = computer([7, 5, 4, 1, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 4, 1]
    assert_equal c.instruction_params, [3, 2, 1]
    c.advance
    assert_equal c.get(1), 0
    assert_equal c.pointer, 4
  end

  def test_eight_with_equal
    c = computer([8, 5, 4, 1, 3, 3], [666])
    assert_equal c.instruction_raw_params, [5, 4, 1]
    assert_equal c.instruction_params, [3, 3, 1]
    c.advance
    assert_equal c.get(1), 1
    assert_equal c.pointer, 4
  end

  def test_eight_with_unequal
    c = computer([8, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_params, [3, 5, 4]
    c.advance
    assert_equal c.get(4), 0
    assert_equal c.pointer, 4
  end

  def test_position_or_immediate
    c = computer([101, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_modes, ['1']
    assert_equal c.instruction_params, [5, 5, 4]

    c = computer([104, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5]
    assert_equal c.instruction_modes, ['1']
    assert_equal c.instruction_params, [5]
    #-----
    c = computer([1001, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_modes, ['0', '1']
    assert_equal c.instruction_params, [3, 1, 4]

    c = computer([1005, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1]
    assert_equal c.instruction_modes, ['0', '1']
    assert_equal c.instruction_params, [3, 1]
    #-----
    c = computer([1101, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_modes, ['1', '1']
    assert_equal c.instruction_params, [5, 1, 4]

    c = computer([1105, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1]
    assert_equal c.instruction_modes, ['1', '1']
    assert_equal c.instruction_params, [5, 1]
    #-----
    c = computer([10001, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_modes, ['0', '0', '1']
    assert_equal c.instruction_params, [3, 5, 4]

    c = computer([10101, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_modes, ['1', '0', '1']
    assert_equal c.instruction_params, [5, 5, 4]
    #-----
    c = computer([11001, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_modes, ['0', '1', '1']
    assert_equal c.instruction_params, [3, 1, 4]

    c = computer([11101, 5, 1, 4, 2, 3], [666])
    assert_equal c.instruction_raw_params, [5, 1, 4]
    assert_equal c.instruction_modes, ['1', '1', '1']
    assert_equal c.instruction_params, [5, 1, 4]
  end

  def test_case_1
    c = computer([1002, 4, 3, 4, 33])
    assert_equal c.run.result, [1002, 4, 3, 4, 99]
  end

  def test_case_2
    c = computer([1101, 100, -1, 4, 0])
    assert_equal c.run.result, [1101, 100, -1, 4, 99]
  end
end

