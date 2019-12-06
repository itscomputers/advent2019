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

  def test_get_and_set_planetary_object
    orbit_graph = OrbitGraph.new([])
    refute orbit_graph.planetary_objects.key? 'not a planet'
    not_a_planet = orbit_graph.get_planetary_object('not a planet')
    assert_equal not_a_planet.class, PlanetaryObject
    assert orbit_graph.planetary_objects.key? 'not a planet'
  end

  def test_record_orbit_string
    orbit_graph = OrbitGraph.new([])
    orbit_graph.record_orbit_string('one)two')
    assert orbit_graph.planetary_objects.key? 'one'
    assert orbit_graph.planetary_objects.key? 'two'
    assert_equal(
      orbit_graph.planetary_objects['two'].orbited_object,
      orbit_graph.planetary_objects['one'],
    )
    orbit_graph.record_orbit_string('one)three')
    assert orbit_graph.planetary_objects.key? 'three'
    assert_equal(
      orbit_graph.planetary_objects['three'].orbited_object,
      orbit_graph.planetary_objects['one'],
    )
  end

  def test_build
    orbit_graph = OrbitGraph.new(@orbit_strings)
    orbit_graph.build
    assert_equal orbit_graph.planetary_objects.keys, %w(COM A B C D E)
  end

  def test_total_orbits
    assert_equal OrbitGraph.new(@orbit_strings).build.total_orbits, 11
  end

  def test_common_parent
    orbit_graph = OrbitGraph.new(@orbit_strings).build
    object_a = orbit_graph.get_planetary_object('A')
    object_c = orbit_graph.get_planetary_object('C')
    object_e = orbit_graph.get_planetary_object('E')
    assert_equal orbit_graph.common_parent([object_c, object_e]), object_a
  end

  def test_distance
    orbit_graph = OrbitGraph.new(@orbit_strings).build
    object_c = orbit_graph.get_planetary_object('C')
    object_e = orbit_graph.get_planetary_object('E')
    assert_equal orbit_graph.distance([object_c, object_e]), 2
  end
end

class TestPlanetaryObject < MiniTest::Test
  def setup
    @center_of_mass = PlanetaryObject.new(name: 'COM')
    @object_a = PlanetaryObject.new(name: 'a', orbited_object: @center_of_mass)
    @object_b = PlanetaryObject.new(name: 'b', orbited_object: @object_a)
  end

  def test_can_set_orbited_object
    assert_equal @object_a.orbited_object, @center_of_mass
    @object_a.orbited_object = @object_b
    assert_equal @object_a.orbited_object, @object_b
    @object_a.orbited_object = @center_of_mass
    assert_equal @object_a.orbited_object, @center_of_mass
  end

  def test_is_center_of_mass
    assert @center_of_mass.is_center_of_mass?
    refute @object_a.is_center_of_mass?
    refute @object_b.is_center_of_mass?
  end

  def test_number_of_orbits
    assert_equal @center_of_mass.number_of_orbits, 0
    assert_equal @object_a.number_of_orbits, 1
    assert_equal @object_b.number_of_orbits, 2
  end

  def parents
    assert_equal @center_of_mass.parents, []
    assert_equal @object_a.parents [@center_of_mass]
    assert_equal @object_b.paretns [@object_b, @center_of_mass]
  end
end

