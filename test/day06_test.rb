require 'test_helper'
require_relative "../lib/day06"

class TestDay06 < MiniTest::Test
  def setup
    @testing = {
      [
        'COM)B',
        'B)C',
        'C)D',
        'D)E',
        'E)F',
        'B)G',
        'G)H',
        'D)I',
        'E)J',
        'J)K',
        'K)L'
      ] => [42, 4],
      [
        'COM)B',
        'B)C',
        'C)D',
        'D)E',
        'E)F',
        'B)G',
        'G)H',
        'D)I',
        'E)J',
        'J)K',
        'K)L',
        'K)YOU',
        'I)SAN'
      ] => [54, 4]
    }
  end

  def test_result_one
    @testing.each do |test_data, results|
      assert_equal Day06.new(test_data).run_one, results.first
    end
  end

  def test_result_two
    @testing.each do |test_data, results|
      assert_equal Day06.new(test_data).run_two, results.last
    end
  end
end

class TestOrbitsGraph < MiniTest::Test
  "COM -- A -- B -- C
          \
           D -- E"

  def setup
    @orbit_strings = ['COM)A', 'A)B', 'B)C', 'A)D', 'D)E']
  end

  def test_get_and_set_planet
    orbit_graph = OrbitGraph.new([])
    refute orbit_graph.planets.key? 'not a planet'
    not_a_planet = orbit_graph.get_planet('not a planet')
    assert_equal not_a_planet.class, Planet
    assert orbit_graph.planets.key? 'not a planet'
  end

  def test_record_orbit_string
    orbit_graph = OrbitGraph.new([])
    orbit_graph.record_orbit_string('one)two')
    assert orbit_graph.planets.key? 'one'
    assert orbit_graph.planets.key? 'two'
    assert_equal(
      orbit_graph.planets['two'].orbited,
      orbit_graph.planets['one'],
    )
    orbit_graph.record_orbit_string('one)three')
    assert orbit_graph.planets.key? 'three'
    assert_equal(
      orbit_graph.planets['three'].orbited,
      orbit_graph.planets['one'],
    )
  end

  def test_build
    orbit_graph = OrbitGraph.new(@orbit_strings)
    orbit_graph.build
    assert_equal orbit_graph.planets.keys, %w(COM A B C D E)
  end

  def test_total_orbits
    assert_equal OrbitGraph.new(@orbit_strings).build.total_orbits, 11
  end

  def test_common_ancestor
    orbit_graph = OrbitGraph.new(@orbit_strings).build
    planet_a = orbit_graph.get_planet('A')
    planet_c = orbit_graph.get_planet('C')
    planet_e = orbit_graph.get_planet('E')
    assert_equal orbit_graph.common_ancestor([planet_c, planet_e]), planet_a
  end

  def test_distance
    orbit_graph = OrbitGraph.new(@orbit_strings).build
    planet_c = orbit_graph.get_planet('C')
    planet_e = orbit_graph.get_planet('E')
    assert_equal orbit_graph.distance([planet_c, planet_e]), 2
  end
end

class TestPlanetaryObject < MiniTest::Test
  def setup
    @center_of_mass = Planet.new(name: 'COM')
    @planet_a = Planet.new(name: 'a', orbited: @center_of_mass)
    @planet_b = Planet.new(name: 'b', orbited: @planet_a)
  end

  def test_can_set_orbited_planet
    assert_equal @planet_a.orbited, @center_of_mass
    @planet_a.orbited= @planet_b
    assert_equal @planet_a.orbited, @planet_b
    @planet_a.orbited= @center_of_mass
    assert_equal @planet_a.orbited, @center_of_mass
  end

  def test_is_center_of_mass
    assert @center_of_mass.is_center_of_mass?
    refute @planet_a.is_center_of_mass?
    refute @planet_b.is_center_of_mass?
  end

  def test_number_of_orbits
    assert_equal @center_of_mass.number_of_orbits, 0
    assert_equal @planet_a.number_of_orbits, 1
    assert_equal @planet_b.number_of_orbits, 2
  end

  def ancestors
    assert_equal @center_of_mass.ancestors, []
    assert_equal @planet_a.ancestors [@center_of_mass]
    assert_equal @planet_b.ancestors [@planet_b, @center_of_mass]
  end
end

