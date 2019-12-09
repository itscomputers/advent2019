require_relative 'solver'
require_relative 'utils'

class Day04 < Solver
  def get_data
    '152085-670283'
  end

  def run_one
    all_digit_counts.count(&method(:has_repeat?))
  end

  def run_two
    all_digit_counts.count(&method(:has_double?))
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

  def is_increasing?(password)
    password.split('').each_cons(2).inject(true) { |bool, pair| bool && pair.reduce(:<=) }
  end

  def increasing_passwords
    @increasing_passwords ||= (lower_bound..upper_bound).select(&method(:is_increasing?))
  end

  def digit_counts_of(password)
    password.split('').count_by(&:itself)
  end

  def all_digit_counts
    @all_digit_counts ||= increasing_passwords.map(&method(:digit_counts_of))
  end

  def has_repeat?(counts)
    counts.values.max >= 2
  end

  def has_double?(counts)
    counts.values.include? 2
  end
end

