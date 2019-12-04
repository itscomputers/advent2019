require_relative 'solver'

class Day01 < Solver
  def get_data
    File.readlines(file_name).map(&:to_i)
  end

  def fuel(mass)
    (mass / 3) - 2
  end

  def fuel_for_fuel(mass, acc=-mass)
    return acc if mass <= 0
    fuel_for_fuel(fuel(mass), acc + mass)
  end

  def run_one
    data.map(&method(:fuel)).sum
  end

  def run_two
    data.map(&method(:fuel_for_fuel)).sum
  end
end

