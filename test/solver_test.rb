require 'test_helper'
require_relative '../lib/solver'

class SolutionTest < Minitest::Test
  def setup
    @solver = ::Solver.new('data')
  end

  def test_file_name
    assert_equal @solver.file_name, 'data/dayve.txt'
  end

  def test_responds_to_get_data
    assert_respond_to @solver, :get_data
  end

  def test_responds_to_run_one
    assert_respond_to @solver, :run_one
  end

  def test_responds_to_run_two
    assert_respond_to @solver, :run_two
  end

  def test_get_data_unimplemented
    assert_raises(NotImplementedError) { @solver.get_data }
  end

  def test_run_one_unimplemented_
    assert_raises(NotImplementedError) { @solver.run_one }
  end

  def test_run_two_unimplemented
    assert_raises(NotImplementedError) { @solver.run_two }
  end
end
