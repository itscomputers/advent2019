class IntcodeComputer
  attr_reader :pointer, :result, :output

  def initialize(program:, input: nil)
    @program = program
    @input = input
    @pointer = 0
    @output = []
    @result = program.map(&:dup)
  end

  def advance
    eval("#{instruction_op}(#{instruction_params})")
    self
  end

  def advance_to_next_output
    output_count = @output.count
    while @output.count == output_count
      advance
    end
    self
  end

  def run
    while instruction_op_id != 99
      advance
    end
    self
  end

  def reset
    @pointer = 0
    @output = []
    @result = @program.map(&:dup)
    self
  end

  #---------------------------
  # instructions
  #---------------------------

  def instruction_length
    {
      1 => 3,
      2 => 3,
      3 => 1,
      4 => 1,
      5 => 2,
      6 => 2,
      7 => 3,
      8 => 3,
      99 => -1,
    }[instruction_op_id]
  end

  def instruction_op
    {
      1 => 'one',
      2 => 'two',
      3 => 'three',
      4 => 'four',
      5 => 'five',
      6 => 'six',
      7 => 'seven',
      8 => 'eight',
    }[instruction_op_id]
  end

  def instruction_pointer_jump
    instruction_length + 1
  end

  def instruction_raw
    @result.slice(@pointer, instruction_pointer_jump)
  end

  def instruction_op_id
    get(@pointer) % 100
  end

  def instruction_modes
    (get(@pointer) / 100).to_s.split('').reverse
  end

  def instruction_raw_params
    instruction_raw.drop(1)
  end

  def instruction_params
    [4, 5, 6].include?(instruction_op_id) ?
      transform_params(instruction_raw_params) :
      transform_params(instruction_raw_params[0...-1]) + [instruction_raw_params.last]
  end

  def transform_params(params)
    params.zip(instruction_modes).map do |pair|
      pair.last == '1' ? pair.first : get(pair.first)
    end
  end

  #---------------------------
  # functions
  #---------------------------

  def set(pointer, value)
    @result[pointer] = value
  end

  def get(pointer)
    @result[pointer]
  end

  #---------------------------
  # operations
  #---------------------------

  def one(params)
    set(params.last, params[0...-1].reduce(0, :+))
    @pointer += instruction_pointer_jump
  end

  def two(params)
    set(params.last, params[0...-1].reduce(1, :*))
    @pointer += instruction_pointer_jump
  end

  def three(params)
    set(params.first, @input)
    @pointer += instruction_pointer_jump
  end

  def four(params)
    @output = @output + params
    @pointer += instruction_pointer_jump
  end

  def five(params)
    if params.first != 0
      @pointer = params.last
    else
      @pointer += instruction_pointer_jump
    end
  end

  def six(params)
    if params.first == 0
      @pointer = params.last
    else
      @pointer += instruction_pointer_jump
    end
  end

  def seven(params)
    set(params.last, (params.first < params[1]) ? 1 : 0)
    @pointer += instruction_pointer_jump
  end

  def eight(params)
    set(params.last, (params.first == params[1]) ? 1 : 0)
    @pointer += instruction_pointer_jump
  end
end

