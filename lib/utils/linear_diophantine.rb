class LinearDiophantine
  def initialize(a, b, c, x_range:, y_range:)
    @a = a
    @b = b
    @c = c
    @d = @a.gcd(@b)
    @x_range = x_range
    @y_range = y_range
  end

  def bezout
    return [1, 0] if @b == 0

    a, b = [@a, @b]
    q, r = a.divmod(b)
    x = [0, 1]
    y = [1, -q]
    while r != 0
      a, b = [b, r]
      q, r = a.divmod(b)
      x = [x.last, x.first - q * x.last]
      y = [y.last, y.first - q * y.last]
    end
    [x.first, y.first]
  end

  def first_solution
    raise ValueError unless @c % @d == 0
    @first_solution ||= bezout.map { |x| x * @c / @d }
  end

  def x(t)
    first_solution.first + @b / @d * t
  end

  def y(t)
    first_solution.last - @a / @d * t
  end

  def solution(t)
    [x(t), y(t)]
  end

  def t_lower
    [(@x_range.first - x(0)).to_f * @d / @b, (y(0) - @y_range.last).to_f * @d / @a].max.ceil
  end

  def t_upper
    [(@x_range.last - x(0)).to_f * @d / @b, (y(0) - @y_range.first).to_f * @d / @a].min.floor
  end

  def solutions_in_range
    (t_lower..t_upper).map do |t|
      solution(t)
    end
  end
end

