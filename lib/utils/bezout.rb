class Bezout
  def initialize(*numbers)
    @a, @b = numbers
    @d = @a.gcd(@b)
    @numbers = numbers
  end

  def primary_solution
    return [1, 0] if @b == 0

    a, b = @numbers
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

  def first_solution(c)
    raise ValueError unless c % @d == 0
    primary_solution.map { |x| x * c / @d }
  end

  def x(c, t)
    first_solution(c).first + @b / @d * t
  end

  def y(c, t)
    first_solution(c).last - @a / @d * t
  end

  def solution(c, t)
    [x(c, t), y(c, t)]
  end

  def t_lower(c, x0, y0, x_lower, y_upper)
    [(x_lower - x0).to_f * @d / @b, (y0 - y_upper).to_f * @d / @a].max.ceil
  end

  def t_upper(c, x0, y0, x_upper, y_lower)
    [(x_upper - x0).to_f * @d / @b, (y0 - y_lower).to_f * @d / @a].min.floor
  end

  def solutions_in_range(c, x_range, y_range)
    x0, y0 = first_solution(c)
    x_lower, x_upper = x_range
    y_lower, y_upper = y_range
    (t_lower(c, x0, y0, x_lower, y_upper)..t_upper(c, x0, y0, x_upper, y_lower)).map do |t|
      solution(c, t)
    end
  end
end

