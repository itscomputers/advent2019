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
  attr_reader :planetary_objects

  def initialize(orbit_strings)
    @orbit_strings = orbit_strings
    @planetary_objects = {}
  end

  def get_planetary_object(name)
    @planetary_objects[name] ||= PlanetaryObject.new(name: name)
  end

  def record_orbit_string(orbit_string)
    orbited, orbiting = orbit_string.split(')').map(&method(:get_planetary_object))
    orbiting.orbited_object = orbited
  end

  def build
    @orbit_strings.each(&method(:record_orbit_string))
    self
  end

  def total_orbits
    @planetary_objects.values.map(&:number_of_orbits).sum
  end

  def common_parent(objects)
    objects.map(&:parents).reduce(:&).first
  end

  def distance(two_objects)
    parent = common_parent(two_objects)
    two_objects.map { |obj| obj.parents.index(parent) }.sum
  end

  def distance_by_name(two_names)
    distance(two_names.map(&method(:get_planetary_object)))
  end
end


class PlanetaryObject
  attr_reader :name, :orbited_object

  def initialize(name:, orbited_object: nil)
    @name = name
    @orbited_object = orbited_object
  end

  def orbited_object=(orbited_object)
    @orbited_object = orbited_object
  end

  def is_center_of_mass?
    @orbited_object.nil?
  end

  def number_of_orbits
    parents.count
  end

  def parents
    return [] if is_center_of_mass?
    @parents ||= [orbited_object, *orbited_object.parents]
  end
end
