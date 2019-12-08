class Solver
  def initialize(test_data=nil)
    @test_data = test_data
  end

  def data
    @test_data || get_data
  end

  def file_name
    "data/day#{self.class.to_s[3..4]}.txt"
  end

  def get_data
    raise NotImplementedError
  end

  def run_one
    raise NotImplementedError
  end

  def run_two
    raise NotImplementedError
  end
end
