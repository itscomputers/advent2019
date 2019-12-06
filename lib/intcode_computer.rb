class IntcodeComputer
  attr_reader :pointer, :result

  def initialize(program:, inputs: [])
    @program = program
    @inputs = inputs
    @pointer = 0
    @output = []
    @result = program.map(&:dup)
  end

  def advance
    opcode[:func].call(op_inputs)
    @pointer += opcode[:length] + 1
    self
  end

  def run
    while get(@pointer) != 99
      advance
    end
    self
  end

  def reset
    @result = @program.map(&:dup)
    @pointer = 0
    self
  end

  def opcode
    {
      1 => { :func => lambda { |inputs| one(inputs) }, :length => 3 },
      2 => { :func => lambda { |inputs| two(inputs) }, :length => 3 },
    }[get(@pointer)]
  end

  def op_inputs
    @program[@pointer+1..@pointer+opcode[:length]]
  end

  def add(inputs)
    inputs.reduce(0, :+)
  end

  def multiply(inputs)
    inputs.reduce(1, :*)
  end

  def set(pointer, value)
    @result[pointer] = value
  end

  def get(pointer)
    @result[pointer]
  end

  def one(inputs)
    *input_pointers, output_pointer = inputs
    set(output_pointer, add(input_pointers.map(&method(:get))))
  end

  def two(inputs)
    *input_pointers, output_pointer = inputs
    set(output_pointer, multiply(input_pointers.map(&method(:get))))
  end
end

