#!/usr/bin/ruby

def create_data_file(day)
  File.open("data/day#{day}.txt", 'w+')
end

def create_day_file(day)
  File.open("lib/day#{day}.rb", 'w+') do |file|
    file.write(day_class(day))
  end
end

def create_test_files(day)
  File.open("test/day#{day}_test.rb", 'w+') do |file|
    file.write(test_class(day))
  end
end

def day_class(day)
  <<~DAY
    require_relative 'solver'

    class Day#{day} < Solver
      def get_data
      end

      def run_one
      end

      def run_two
      end
    end
  DAY
end

def test_class(day)
  <<~TEST
    require 'test_helper'
    require_relative "../lib/day#{day}"

    class TestDay#{day} < MiniTest::Test
      def setup
        @testing = {}
      end

      def test_result_one
        @testing.each do |test_data, results|
          assert_equal Day#{day}.new(test_data).run_one, results.first
        end
      end

      def test_result_two
        @testing.each do |test_data, results|
          assert_equal Day#{day}.new(test_data).run_two, results.last
        end
      end
    end
  TEST
end

DAY_NUMBER = ARGV.first

create_data_file(DAY_NUMBER)
create_day_file(DAY_NUMBER)
create_test_files(DAY_NUMBER)

