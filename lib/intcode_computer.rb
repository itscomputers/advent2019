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
    @relative_base = 0
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

  #---------------------------
  # run the program
  #---------------------------

  def advance
    instr_op.call
    self
  end

  def advance_to_next_output
    until @terminated
      break_after_advance = will_write_to_output?
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

  def current_state
    @result.values
  end

  #---------------------------
  # handle instruction
  #---------------------------

  def instr_router
    {
      1 => { :length => 4, :op => method(:add) },
      2 => { :length => 4, :op => method(:multiply) },
      3 => { :length => 2, :op => method(:write_from_input) },
      4 => { :length => 2, :op => method(:write_to_output) },
      5 => { :length => 3, :op => method(:jump_if_true) },
      6 => { :length => 3, :op => method(:jump_if_false) },
      7 => { :length => 4, :op => method(:less_than) },
      8 => { :length => 4, :op => method(:equals) },
      9 => { :length => 2, :op => method(:relative_base_offset) },
      99 => { :length => 0, :op => method(:halt_program) },
    }
  end

  def instr_op_id
    get(@pointer) % 100
  end

  def instr_op
    instr_router[instr_op_id][:op]
  end

  def instr_length
    instr_router[instr_op_id][:length]
  end

  def instr_params
    @result.slice(*(@pointer+1...@pointer+instr_length)).values
  end

  def instr_modes
    (get(@pointer) / 100).to_s.split('').reverse
  end

  def transform(params, modes)
    params.zip(modes).map do |pair|
      transform_single(*pair)
    end
  end

  def transform_single(param, mode)
    if mode == '1'
      param
    elsif mode == '2'
      get(param + @relative_base)
    else
      get(param)
    end
  end

  def relative_output(pointer)
    (instr_modes.count == instr_params.count && instr_modes.last == '2') ?
      pointer + @relative_base :
      pointer
  end

  def will_write_to_output?
    instr_op_id == 4
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

  def binary_operator(operation)
    *inputs, output_pointer = instr_params
    inputs = transform(inputs, instr_modes)
    output_pointer = relative_output(output_pointer)
    set(output_pointer, inputs.inject(operation))
  end

  def binary_boolean_operator(operation)
    *inputs, output_pointer = instr_params
    inputs = transform(inputs, instr_modes)
    output_pointer = relative_output(output_pointer)
    set(output_pointer, inputs.inject(operation) ? 1 : 0)
  end

  def jump_after
    jump = instr_length
    yield
    move_pointer_by(jump)
  end

  def add
    jump_after { binary_operator(:+) }
  end

  def multiply
    jump_after { binary_operator(:*) }
  end

  def write_from_input
    output_pointer = relative_output(instr_params.last)
    jump_after { set(output_pointer, next_input) }
  end

  def write_to_output
    jump_after { @outputs = @outputs + transform(instr_params, instr_modes) }
  end

  def jump_if(bool)
    params = transform(instr_params, instr_modes)
    (bool ? params.first != 0 : params.first == 0) ?
      move_pointer_to(params.last) :
      move_pointer_by(instr_length)
  end

  def jump_if_true
    jump_if(true)
  end

  def jump_if_false
    jump_if(false)
  end

  def less_than
    jump_after { binary_boolean_operator(:<) }
  end

  def equals
    jump_after { binary_boolean_operator(:==) }
  end

  def relative_base_offset
    jump_after { @relative_base = @relative_base + transform(instr_params, instr_modes).first }
  end

  def halt_program
    @terminated = true
  end
end

