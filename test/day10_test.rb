require 'test_helper'
require_relative "../lib/day10"

class TestDay10 < MiniTest::Test
  def test_case_1
    test_data = %w(
      .#..#
      .....
      #####
      ....#
      ...##
    )
    assert_equal Day10.new(test_data).asteroid_monitor.maximum_visible, 8
    assert_equal Day10.new(test_data).asteroid_monitor.center, [3, 4]
  end

  def test_case_2
    test_data = %w(
      ......#.#.
      #..#.#....
      ..#######.
      .#.#.###..
      .#..#.....
      ..#....#.#
      #..#....#.
      .##.#..###
      ##...#..#.
      .#....####
    )
    assert_equal Day10.new(test_data).asteroid_monitor.maximum_visible, 33
    assert_equal Day10.new(test_data).asteroid_monitor.center, [5, 8]
  end

  def test_case_3
    test_data = %w(
      #.#...#.#.
      .###....#.
      .#....#...
      ##.#.#.#.#
      ....#.#.#.
      .##..###.#
      ..#...##..
      ..##....##
      ......#...
      .####.###.
    )
    assert_equal Day10.new(test_data).asteroid_monitor.maximum_visible, 35
    assert_equal Day10.new(test_data).asteroid_monitor.center, [1, 2]
  end

  def test_case_4
    test_data = %w(
      .#..#..###
      ####.###.#
      ....###.#.
      ..###.##.#
      ##.##.#.#.
      ....###..#
      ..#.#..#.#
      #..#.#.###
      .##...##.#
      .....#.#..
    )
    assert_equal Day10.new(test_data).asteroid_monitor.maximum_visible, 41
    assert_equal Day10.new(test_data).asteroid_monitor.center, [6, 3]
  end

  def test_case_5
    test_data = %w(
      .#..##.###...#######
      ##.############..##.
      .#.######.########.#
      .###.#######.####.#.
      #####.##.#.##.###.##
      ..#####..#.#########
      ####################
      #.####....###.#.#.##
      ##.#################
      #####.##.###..####..
      ..######..##.#######
      ####.##.####...##..#
      .#####..#.######.###
      ##...#.##########...
      #.##########.#######
      .####.#.###.###.#.##
      ....##.##.###..#####
      .#.#.###########.###
      #.#.#.#####.####.###
      ###.##.####.##.#..##
    )
    assert_equal Day10.new(test_data).asteroid_monitor.maximum_visible, 210
    assert_equal Day10.new(test_data).asteroid_monitor.center, [11, 13]
    to_vaporize = Day10.new(test_data).asteroid_monitor.ordered_visible
    [
      [ 0,  [11,12]],
      [ 1,  [12, 1]],
      [ 2,  [12, 2]],
      [ 9,  [12, 8]],
      [ 19, [16, 0]],
      [ 49, [16, 9]],
      [ 99, [10,16]],
      [198, [ 9, 6]],
      [199, [ 8, 2]],
      [200, [10, 9]]
    ].each do |pair|
      assert_equal to_vaporize[pair.first], pair.last
    end
  end
end


