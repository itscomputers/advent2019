require 'test_helper'
require_relative "../lib/day06"

class TestDay06 < MiniTest::Test
  def setup
    @testing = [
      {
        :orbit_strings => %w[COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L],
        :total_orbits => 42,
        :distance => 4,
      },
      {
        :orbit_strings => %w[COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L K)YOU I)SAN],
        :total_orbits => 54,
        :distance => 4,
      }
    ]
  end

  def test_case_one_run_one
    assert_equal Day06.new(@testing.first[:orbit_strings]).run_one, @testing.first[:total_orbits]
  end

  def test_case_two_run_one
    assert_equal Day06.new(@testing.last[:orbit_strings]).run_one, @testing.last[:total_orbits]
  end

  def test_case_one_run_two
    assert_equal Day06.new(@testing.first[:orbit_strings]).run_two, @testing.first[:distance]
  end

  def test_case_two_run_two
    assert_equal Day06.new(@testing.last[:orbit_strings]).run_two, @testing.last[:distance]
  end
end

