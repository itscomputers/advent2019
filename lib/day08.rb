require_relative 'solver'

class Day08 < Solver
  def get_data
    File.read(file_name).strip
  end

  def run_one
    image = Image.new(data, *width_and_height)
    image.counts[image.min_zero_layer_id].slice('1', '2').values.map(&:to_i).reduce(1, :*)
  end

  def run_two
    puts decoded_image
  end

  def width_and_height
    @test_data ? [2, 2] : [25, 6]
  end

  def image
    @image ||= Image.new(data, *width_and_height)
  end

  def decoded_image(ch0=' ', ch1='#')
     image.display(ch0, ch1)
  end
end

class Image
  def initialize(data, width, height)
    @data = data
    @width = width
    @area = width * height
  end

  def layers
    @layers ||= @data.split('').each_slice(@area)
  end

  def combine_layers(upper, lower)
    upper.zip(lower).map { |pair| pair.first == '2' ? pair.last: pair.first }
  end

  def decoded_image
    @decoded_image ||= layers.inject { |x, y| combine_layers(x, y) }
  end

  def counts
    @counts ||= layers.map { |layer| layer.count_by(&:itself) }
  end

  def min_zero_layer_id
    counts.index(counts.min_by { |hash| hash['0'] || 0 })
  end

  def display(ch0=nil, ch1=nil)
    print_layer(decoded_image, ch0, ch1)
  end

  def print_layer(layer, ch0, ch1)
    rows = layer.each_slice(@width).map { |t| t.join('') }
    rows = rows.map { |r| r.gsub('0', ch0) } if ch0
    rows = rows.map { |r| r.gsub('1', ch1) } if ch1
    rows
  end
end

module Enumerable
  def count_by(&block)
    each_with_object(Hash.new(0)) do |elem, memo|
      value = block.call(elem)
      memo[value] += 1
    end
  end
end

