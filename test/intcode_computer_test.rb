require 'test_helper'
require_relative '../lib/intcode_computer'

class TestIntcodeComputer < MiniTest::Test
  def computer(d, i=nil)
    IntcodeComputer.new(program: d, inputs: i)
  end

  def test_set_and_get
    c = computer([5, 4, 3, 2, 1])
    refute_equal c.result[2], 1000
    refute_equal c.get(2), 1000
    c.set(2, 1000)
    assert_equal c.result[2], 1000
    assert_equal c.get(2), 1000
    assert_nil c.result[500]
    assert_equal c.get(500), 0
    c.set(500, 1000)
    assert_equal c.result[500], 1000
    assert_equal c.get(500), 1000
  end

  def test_reset
    program = [3, 0, 4, 0, 99]
    c = computer(program, [666])
    assert_equal c.current_state, program
    assert_nil c.output
    refute c.terminated
    c.run
    refute_equal c.current_state, program
    refute_nil c.output
    assert c.terminated
    assert_raises(StopIteration) { c.inputs.next }
    c.reset
    assert_equal c.current_state, program
    assert_nil c.output
    refute c.terminated
    assert_silent { c.inputs.next }
  end

  def test_add
    [
      { :test_data => [   1, 5,1,4,2,3], :result => 3 + 5 },
      { :test_data => [ 101, 5,1,4,2,3], :result => 5 + 5 },
      { :test_data => [1101, 5,1,4,2,3], :result => 5 + 1 },
      { :test_data => [1001, 5,1,4,2,3], :result => 3 + 1 },
    ].each do |hash|
      c = IntcodeComputer.new(program: hash[:test_data]).advance
      assert_equal c.get(4), hash[:result]
      assert_equal c.pointer, 4
    end
  end

  def test_multiply
    [
      { :test_data => [   2, 5,1,4,2,3], :result => 3 * 5 },
      { :test_data => [ 102, 5,1,4,2,3], :result => 5 * 5 },
      { :test_data => [1102, 5,1,4,2,3], :result => 5 * 1 },
      { :test_data => [1002, 5,1,4,2,3], :result => 3 * 1 },
    ].each do |hash|
      c = IntcodeComputer.new(program: hash[:test_data]).advance
      assert_equal c.get(4), hash[:result]
      assert_equal c.pointer, 4
    end
  end

  def test_write_from_input
    input = 666
    [
      { :test_data => [   3, 5,1,4,2,3], :result => input },
      { :test_data => [ 103, 5,1,4,2,3], :result => input },
      { :test_data => [1103, 5,1,4,2,3], :result => input },
      { :test_data => [1003, 5,1,4,2,3], :result => input },
    ].each do |hash|
      c = IntcodeComputer.new(program: hash[:test_data], inputs: [input]).advance
      assert_equal c.get(5), input
      assert_equal c.pointer, 2
    end
  end

  def test_write_from_default_input
    input = 666
    [
      { :test_data => [   3, 5,1,4,2,3], :result => input },
      { :test_data => [ 103, 5,1,4,2,3], :result => input },
      { :test_data => [1103, 5,1,4,2,3], :result => input },
      { :test_data => [1003, 5,1,4,2,3], :result => input },
    ].each do |hash|
      c = IntcodeComputer.new(program: hash[:test_data], default_input: input).advance
      assert_equal c.get(5), input
      assert_equal c.pointer, 2
    end
  end

  def test_write_to_output
    [
      { :test_data => [   4, 5,1,4,2,3], :result => 3 },
      { :test_data => [ 104, 5,1,4,2,3], :result => 5 },
    ].each do |hash|
      c = IntcodeComputer.new(program: hash[:test_data]).advance
      assert_equal c.outputs, [hash[:result]]
      assert_equal c.output, hash[:result]
      assert_equal c.pointer, 2
    end
  end

  def test_jump_if_true
    [
      { :test_data => [   5, 5,1,4,2,3], :result => 5 },
      { :test_data => [ 105, 5,1,4,2,3], :result => 5 },
      { :test_data => [1105, 5,1,4,2,3], :result => 1 },
      { :test_data => [1005, 5,1,4,2,3], :result => 1 },
      { :test_data => [   5, 5,1,4,2,0], :result => 3 },
      { :test_data => [ 105, 0,1,4,2,3], :result => 3 },
      { :test_data => [1105, 0,1,4,2,3], :result => 3 },
      { :test_data => [1005, 5,1,4,2,0], :result => 3 },
    ].each do |hash|
      assert_equal IntcodeComputer.new(program: hash[:test_data]).advance.pointer, hash[:result]
    end
  end

  def test_jump_if_false
    [
      { :test_data => [   6, 5,1,4,2,0], :result => 5 },
      { :test_data => [ 106, 0,1,4,2,3], :result => 0 },
      { :test_data => [1106, 0,1,4,2,3], :result => 1 },
      { :test_data => [1006, 5,1,4,2,0], :result => 1 },
      { :test_data => [   6, 5,1,4,2,3], :result => 3 },
      { :test_data => [ 106, 5,1,4,2,3], :result => 3 },
      { :test_data => [1106, 5,1,4,2,3], :result => 3 },
      { :test_data => [1006, 5,1,4,2,3], :result => 3 },
    ].each do |hash|
      assert_equal IntcodeComputer.new(program: hash[:test_data]).advance.pointer, hash[:result]
    end
  end

  def test_less_than
    [
      { :test_data => [   7, 5,1,4,2,3], :result => 1 },
      { :test_data => [ 107, 1,5,4,2,3], :result => 1 },
      { :test_data => [1107, 1,5,4,2,3], :result => 1 },
      { :test_data => [1007, 5,4,4,2,3], :result => 1 },
      { :test_data => [   7, 5,1,4,2,6], :result => 0 },
      { :test_data => [ 107, 5,1,4,2,3], :result => 0 },
      { :test_data => [1107, 5,1,4,2,3], :result => 0 },
      { :test_data => [1007, 5,3,4,2,3], :result => 0 },
    ].each do |hash|
      assert_equal IntcodeComputer.new(program: hash[:test_data]).advance.get(4), hash[:result]
    end
  end

  def test_equals
    [
      { :test_data => [   8, 5,4,4,3,3], :result => 1 },
      { :test_data => [ 108, 5,1,4,2,3], :result => 1 },
      { :test_data => [1108, 5,5,4,2,3], :result => 1 },
      { :test_data => [1008, 5,3,4,2,3], :result => 1 },
      { :test_data => [   8, 5,1,4,2,6], :result => 0 },
      { :test_data => [ 108, 5,4,4,2,3], :result => 0 },
      { :test_data => [1108, 5,1,4,2,3], :result => 0 },
      { :test_data => [1008, 5,1,4,2,3], :result => 0 },
    ].each do |hash|
      assert_equal IntcodeComputer.new(program: hash[:test_data]).advance.get(4), hash[:result]
    end
  end

  def test_case_1
    c = computer([1002, 4, 3, 4, 33])
    assert_equal c.run.current_state, [1002, 4, 3, 4, 99]
  end

  def test_case_2
    c = computer([1101, 100, -1, 4, 0])
    assert_equal c.run.current_state, [1101, 100, -1, 4, 99]
  end
end

