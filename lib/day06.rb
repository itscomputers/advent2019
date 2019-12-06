require_relative 'solver'

class Day06 < Solver
  def get_data
    File.read(file_name).split
  end

  def run_one
    OrbitGraph.new(data).build.total_orbits
  end

  def run_two
    return OrbitGraph.new(data).build.distance_by_name(['L', 'D']) if @data
    OrbitGraph.new(data).build.distance_by_name(['YOU', 'SAN'])
  end
end

class OrbitGraph
  attr_reader :planets

  def initialize(orbit_strings)
    @orbit_strings = orbit_strings
    @planets = {}
  end

  def get_planet(name)
    @planets[name] ||= Planet.new(name: name)
  end

  def record_orbit_string(orbit_string)
    orbited_planet, orbiting_planet = orbit_string.split(')').map(&method(:get_planet))
    orbiting_planet.orbited = orbited_planet
  end

  def build
    @orbit_strings.each(&method(:record_orbit_string))
    self
  end

  def total_orbits
    @planets.values.map(&:number_of_orbits).sum
  end

  def common_ancestor(planets)
    planets.map(&:ancestors).reduce(:&).first
  end

  def distance(two_planets)
    ancestor = common_ancestor(two_planets)
    two_planets.map { |planet| planet.ancestors.index(ancestor) }.sum
  end

  def distance_by_name(two_names)
    distance(two_names.map(&method(:get_planet)))
  end
end


class Planet
  attr_reader :name, :orbited

  def initialize(name:, orbited: nil)
    @name = name
    @orbited = orbited
  end

  def orbited=(planet)
    @orbited = planet
  end

  def is_center_of_mass?
    @orbited.nil?
  end

  def number_of_orbits
    ancestors.count
  end

  def ancestors
    return [] if is_center_of_mass?
    @ancestors ||= [@orbited, *@orbited.ancestors]
  end
end
