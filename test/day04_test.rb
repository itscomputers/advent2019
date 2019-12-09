require 'test_helper'
require_relative "../lib/day04"

class TestDay04a < MiniTest::Test
  def setup
    @test_data = '000000-999999'
    @passwords = %w(112345 111123 135679 111111 223450 123789 112233 123444 111122).zip(
      [
        [true, true, true],
        [true, true, false],
        [true, false, false],
        [true, true, false],
        [false, true, true],
        [true, false, false],
        [true, true, true],
        [true, true, false],
        [true, true, true],
      ].map do |values|
        [:increasing, :has_repeat, :has_double].zip(values).to_h
      end
    ).to_h
    @day = Day04.new(@test_data)
  end

  def test_increasing
    @passwords.each do |password, props|
      assert_equal @day.is_increasing?(password), props[:increasing]
    end
  end

  def test_has_repeat
    @passwords.each do |password, props|
      assert_equal @day.has_repeat?(@day.digit_counts_of(password)), props[:has_repeat]
    end
  end

  def test_has_double
    @passwords.each do |password, props|
      assert_equal @day.has_double?(@day.digit_counts_of(password)), props[:has_double]
    end
  end

  def test_increasing_passwords
    assert_equal(
      Day04.new('00-99').increasing_passwords.sort,
      (0..9).map do |i|
        (i..9).map { |j| [i, j].join('') }
      end.flatten
    )
  end
end
