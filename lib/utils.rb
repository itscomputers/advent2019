module Utils
  def self.vector_dot(u, v)
    u.zip(v).map { |t| t.reduce(1, :*) }.sum
  end

  def self.vector_add(u, v)
    u.zip(v).map(&:sum)
  end

  def self.matrix_vector_mult(m, v)
    m.map { |row| vector_dot(row, v) }
  end

  def self.grid_rotate(v, dir)
    sign = {
      'cw' => -1,
      'ccw' => 1,
    }[dir]
    matrix_vector_mult([[0, sign], [-sign, 0]], v)
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

