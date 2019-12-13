require 'test_helper'
require_relative "../lib/day12"

class TestDay12 < MiniTest::Test
  def test_case_1
    test_data = ['<x=-1, y=0, z=2>',
                 '<x=2, y=-10, z=-7>',
                 '<x=4, y=-8, z=8>',
                 '<x=3, y=5, z=-1>']
    assert_equal Day12.new(test_data).total_energy_after(10), 179
    assert_equal Day12.new(test_data).steps_until_repeat, 2772
  end

  def test_case_2
    test_data = ['<x=-8, y=-10, z=0>',
                 '<x=5, y=5, z=10>',
                 '<x=2, y=-7, z=3>',
                 '<x=9, y=-8, z=-3>']
    assert_equal Day12.new(test_data).total_energy_after(100), 1940
    assert_equal Day12.new(test_data).steps_until_repeat, 4686774924
  end
end
