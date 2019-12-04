module Utils
  def self.vector_dot(u, v)
    u.zip(v).map { |t| t.reduce(1, :*) }.sum
  end

  def self.vector_add(u, v)
    u.zip(v).map(&:sum)
  end
end

