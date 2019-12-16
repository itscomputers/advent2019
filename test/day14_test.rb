require 'test_helper'
require_relative "../lib/day14"

class TestDay14 < MiniTest::Test
  def setup
    @testing_data = [
      [
        '10 ORE => 10 A',
        '1 ORE => 1 B',
        '7 A, 1 B => 1 C',
        '7 A, 1 C => 1 D',
        '7 A, 1 D => 1 E',
        '7 A, 1 E => 1 FUEL'
      ],
      [
        '9 ORE => 2 A',
        '8 ORE => 3 B',
        '7 ORE => 5 C',
        '3 A, 4 B => 1 AB',
        '5 B, 7 C => 1 BC',
        '4 C, 1 A => 1 CA',
        '2 AB, 3 BC, 4 CA => 1 FUEL',
      ]
    ]
  end

  def test_parse_reaction
    assert_equal(
      Day14.new(@testing_data.first).reactions,
      {
        'A' => { 'ORE' => [10, 10] },
        'B' => { 'ORE' => [1, 1] },
        'C' => { 'A' => [7, 1], 'B' => [1, 1] },
        'D' => { 'A' => [7, 1], 'C' => [1, 1] },
        'E' => { 'A' => [7, 1], 'D' => [1, 1] },
        'FUEL' => { 'A' => [7, 1], 'E' => [1, 1] },
      }
    )
  end

  def test_resolve
    assert_equal Day14.new(@testing_data.first).resolve, 31
    assert_equal Day14.new(@testing_data.last).resolve, 165
  end


end
