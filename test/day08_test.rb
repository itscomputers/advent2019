require 'test_helper'
require_relative "../lib/day08"

class TestImage < MiniTest::Test
  def setup
    @test_cases = [
      {
        :data => '123456789012',
        :width => 3,
        :height => 2,
        :layers => [%w(1 2 3 4 5 6), %w(7 8 9 0 1 2)],
        :counts => [%w(1 2 3 4 5 6), %w(7 8 9 0 1 2)].map { |layer| layer.map { |i| [i, 1] }.to_h },
        :min_zero_layer_id => 0,
        :printed => [%w(123 456), %w(789 012)],
      },
      {
        :data => '0222112222120000',
        :width => 2,
        :height => 2,
        :layers => [%w(0 2 2 2), %w(1 1 2 2), %w(2 2 1 2), %w(0 0 0 0)],
        :counts => [
          {'0' => 1, '2' => 3},
          {'1' => 2, '2' => 2},
          {'1' => 1, '2' => 3},
          {'0' => 4},
        ],
        :min_zero_layer_id => 1,
        :printed => [%w(02 22), %w(11 22), %w(22 12), %w(00 00)],
      }
    ]
  end

  def image(hash)
    Image.new(*hash.slice(:data, :width, :height).values)
  end

  def test_layers
    @test_cases.each do |hash|
      assert_equal image(hash).layers.to_a, hash[:layers]
    end
  end

  def test_counts
    @test_cases.each do |hash|
      assert_equal image(hash).counts, hash[:counts]
    end
  end

  def test_min_zero_layer_id
    @test_cases.each do |hash|
      assert_equal image(hash).min_zero_layer_id, hash[:min_zero_layer_id]
    end
  end

  def test_printed
    @test_cases.each do |hash|
      i = image(hash)
      assert_equal(
        i.layers.map { |layer| i.print_layer(layer, nil, nil) },
        hash[:printed],
      )
    end
  end
end

