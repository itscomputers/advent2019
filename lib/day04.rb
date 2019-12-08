require_relative 'solver'
require_relative 'utils'

class Day04 < Solver
  def get_data
    '152085-670283'
  end

  def run_one
    (lower_bound..upper_bound).count { |n| acceptable? n.to_s, part: 1 }
  end

  def run_two
    (lower_bound..upper_bound).count { |n| acceptable? n.to_s, part: 2 }
  end

  def acceptable?(password, part:)
    matching = in_range(password) && is_increasing(password)
    matching &&= digit_counts(password).values.max >= 2 if part == 1
    matching &&= digit_counts(password).values.include?(2) if part == 2
    matching
  end

  def bounds
    data.split('-')
  end

  def lower_bound
    bounds.first
  end

  def upper_bound
    bounds.last
  end

  def in_range(password)
    lower_bound <= password && password <= upper_bound
  end

  def digit_counts(password)
    password.split('').count_by(&:to_s)
  end

  def is_increasing(password)
    (0...5).map { |i| password[i] <= password[i+1] }.all?
  end
end

