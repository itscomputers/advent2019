class IntcodeComputer
  attr_reader :pointer, :result, :output

  def initialize(program:, inputs: nil, default_input: nil)
    @program = program
    @inputs = inputs.to_enum
    @default_input = default_input
    @pointer = 0
    @output = []
    @result = program.map(&:dup)
  end

  def advance
    eval("#{instruction_op}(#{instruction_params})")
    self
  end

  def advance_to_next_output
    while !final_instruction
      break_after_advance = will_write_to_output
      advance
      break if break_after_advance
    end
    self
  end

  def run
    advance while !final_instruction
    self
  end

  def reset
    @pointer = 0
    @output = []
    @result = @program.map(&:dup)
    self
  end

  def default_input=(value)
    @default_input = value
  end

  def next_input
    return @inputs.next
  rescue StopIteration
    @default_input
  end

  #---------------------------
  # instructions
  #---------------------------

  def instruction_router
    {
      1 => { :length => 3, :op => 'one' },
      2 => { :length => 3, :op => 'two' },
      3 => { :length => 1, :op => 'three' },
      4 => { :length => 1, :op => 'four' },
      5 => { :length => 2, :op => 'five' },
      6 => { :length => 2, :op => 'six' },
      7 => { :length => 3, :op => 'seven' },
      8 => { :length => 3, :op => 'eight' },
    }
  end

  def instruction_length
    instruction_router[instruction_op_id][:length]
  end

  def instruction_op
    instruction_router[instruction_op_id][:op]
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

  def final_instruction
    instruction_op_id == 99
  end

  def will_write_to_output
    instruction_op_id == 4
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
    set(params.first, next_input)
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

