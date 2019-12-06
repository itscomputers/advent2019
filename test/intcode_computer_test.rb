require 'test_helper'
require_relative '../lib/intcode_computer'

class TestIntcodeComputer < MiniTest::Test
  def setup
    @program = [1,9,10,3,2,3,11,0,99,30,40,50]
    @result = [3500,9,10,70,2,3,11,0,99,30,40,50]
    @computer = IntcodeComputer.new(program: @program)
  end

  def test_add
    assert_equal @computer.add([1, 3, 5]), 9
  end

  def test_multiply
    assert_equal @computer.multiply([1, 3, 5]), 15
  end

  def test_set
    refute_equal @computer.result[5], 1000
    @computer.set(5, 1000)
    assert_equal @computer.result[5], 1000
  end

  def test_opcode_one
    @computer.reset
    assert_equal @computer.get(@computer.pointer), 1
    assert_equal @computer.op_inputs, [9, 10, 3]
    @computer.advance
    assert_equal @computer.get(3),  @computer.get(9) + @computer.get(10)
  end

  def test_opcode_two
    @computer.reset.advance
    assert_equal @computer.get(@computer.pointer), 2
    assert_equal @computer.op_inputs, [3, 11, 0]
    @computer.advance
    assert_equal @computer.get(0), @computer.get(3) * @computer.get(11)
  end

  def test_run
    @computer.reset.run
    assert_equal @computer.result, @result
  end

  def test_reset
    @computer.run
    refute_equal @computer.result, @program
    refute_equal @computer.pointer, 0
    @computer.reset
    assert_equal @computer.result, @program
    assert_equal @computer.pointer, 0
  end
end
