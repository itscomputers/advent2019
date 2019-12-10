class IntcodeComputer
  attr_reader :inputs, :outputs, :pointer, :result, :terminated

  def self.run(program:, inputs: [], default_input: nil)
    self.new(
      program: program,
      inputs: inputs,
      default_input: default_input
    ).run
  end

  #---------------------------
  # set and reset state
  #---------------------------

  def initialize(program:, inputs: [], default_input: nil)
    @program = program
    @inputs = inputs.to_enum
    @default_input = default_input
    set_initial_state
  end

  def set_initial_state
    @result = @program.map.with_index { |val, idx| [idx, val] }.to_h
    @pointer = 0
    @outputs = []
    @terminated = false
  end

  def reset_inputs
    @inputs = @inputs.to_a.to_enum
  end

  def reset
    reset_inputs
    set_initial_state
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

  def current_state
    @result.values
  end

  #---------------------------
  # run the program
  #---------------------------

  def advance
    instruction_op.call(instruction_params)
    self
  end

  def advance_to_next_output
    until @terminated
      break_after_advance = will_write_to_output
      advance
      break if break_after_advance
    end
    self
  end

  def run
    advance until @terminated
    self
  end

  def output
    @outputs.last
  end

  #---------------------------
  # handle instruction
  #---------------------------

  def instruction_router
    {
      1 => { :length => 4, :op => method(:add) },
      2 => { :length => 4, :op => method(:multiply) },
      3 => { :length => 2, :op => method(:write_from_input) },
      4 => { :length => 2, :op => method(:write_to_output) },
      5 => { :length => 3, :op => method(:jump_if_true) },
      6 => { :length => 3, :op => method(:jump_if_false) },
      7 => { :length => 4, :op => method(:less_than) },
      8 => { :length => 4, :op => method(:equals) },
      99 => { :length => 0, :op => method(:halt_program) },
    }
  end

  def instruction_op
    instruction_router[instruction_op_id][:op]
  end

  def instruction_pointer_jump
    instruction_router[instruction_op_id][:length]
  end

  def instruction_raw
    @result.slice(*(@pointer...@pointer+instruction_pointer_jump)).values
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
      transform(instruction_raw_params) :
      transform(instruction_raw_params[0...-1]) + [instruction_raw_params.last]
  end

  def transform(params)
    params.zip(instruction_modes).map do |pair|
      pair.last == '1' ? pair.first : get(pair.first)
    end
  end

  def will_write_to_output
    instruction_op_id == 4
  end

  #---------------------------
  # modify state
  #---------------------------

  def set(pointer, value)
    @result[pointer] = value
  end

  def get(pointer)
    @result[pointer] || 0
  end

  def move_pointer_by(value)
    @pointer = @pointer + value
  end

  def move_pointer_to(value)
    @pointer = value
  end

  def binary_operator(operation, params)
    *inputs, output_pointer = params
    set(output_pointer, inputs.inject(operation))
  end

  def binary_boolean_operator(operation, params)
    *inputs, output_pointer = params
    set(output_pointer, inputs.inject(operation) ? 1 : 0)
  end

  def jump_after
    jump = instruction_pointer_jump
    yield
    move_pointer_by(jump)
  end

  def add(params)
    jump_after { binary_operator(:+, params) }
  end

  def multiply(params)
    jump_after { binary_operator(:*, params) }
  end

  def write_from_input(params)
    jump_after { set(params.first, next_input) }
  end

  def write_to_output(params)
    jump_after { @outputs = @outputs + params }
  end

  def jump_if(bool, params)
    (bool ? params.first != 0 : params.first == 0) ?
      move_pointer_to(params.last) :
      move_pointer_by(instruction_pointer_jump)
  end

  def jump_if_true(params)
    jump_if(true, params)
  end

  def jump_if_false(params)
    jump_if(false, params)
  end

  def less_than(params)
    jump_after { binary_boolean_operator(:<, params) }
  end

  def equals(params)
    jump_after { binary_boolean_operator(:==, params) }
  end

  def halt_program(params)
    @terminated = true
  end
end

