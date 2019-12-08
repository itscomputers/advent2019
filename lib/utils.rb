module Utils
  def self.vector_dot(u, v)
    u.zip(v).map { |t| t.reduce(1, :*) }.sum
  end

  def self.vector_add(u, v)
    u.zip(v).map(&:sum)
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

