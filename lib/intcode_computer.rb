class IntcodeComputer
  attr_reader :inputs, :output, :pointer, :result, :terminated

  def self.run(program:, inputs: nil, default_input: nil)
    self.new(
      program: program,
      inputs: inputs,
      default_input: default_input
    ).run
  end

  def initialize(program:, inputs: nil, default_input: nil)
    @program = program
    @inputs = inputs.to_enum
    @default_input = default_input
    @result = program.map(&:dup)
    @pointer = 0
    @outputs = []
    @terminated = false
  end

  def reset
    @inputs = @inputs.to_a.to_enum
    @result = @program.map(&:dup)
    @pointer = 0
    @outputs = []
    @terminated = false
    self
  end

  def output
    @outputs.last
  end

  def advance
    eval("#{instruction_op}(#{instruction_params})")
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
      1 => { :length => 4, :op => 'add' },
      2 => { :length => 4, :op => 'multiply' },
      3 => { :length => 2, :op => 'write_from_input' },
      4 => { :length => 2, :op => 'write_to_output' },
      5 => { :length => 3, :op => 'jump_if_true' },
      6 => { :length => 3, :op => 'jump_if_false' },
      7 => { :length => 4, :op => 'less_than' },
      8 => { :length => 4, :op => 'equals' },
      99 => { :length => 0, :op => 'halt_program' },
    }
  end

  def instruction_op
    instruction_router[instruction_op_id][:op]
  end

  def instruction_pointer_jump
    instruction_router[instruction_op_id][:length]
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
  # functions
  #---------------------------

  def set(pointer, value)
    @result[pointer] = value
  end

  def get(pointer)
    @result[pointer]
  end

  def move_pointer_by(value)
    @pointer = @pointer + value
  end

  def move_pointer_to(value)
    @pointer = value
  end

  #---------------------------
  # operations
  #---------------------------

  def add(params)
    jump = instruction_pointer_jump
    set(params.last, params[0...-1].reduce(0, :+))
    move_pointer_by(jump)
  end

  def multiply(params)
    jump = instruction_pointer_jump
    set(params.last, params[0...-1].reduce(1, :*))
    move_pointer_by(jump)
  end

  def write_from_input(params)
    jump = instruction_pointer_jump
    set(params.first, next_input)
    move_pointer_by(jump)
  end

  def write_to_output(params)
    jump = instruction_pointer_jump
    @outputs = @outputs + params
    move_pointer_by(jump)
  end

  def jump_if_true(params)
    (params.first != 0) ?
      move_pointer_to(params.last) :
      move_pointer_by(instruction_pointer_jump)
  end

  def jump_if_false(params)
    (params.first == 0) ?
      move_pointer_to(params.last) :
      move_pointer_by(instruction_pointer_jump)
  end

  def less_than(params)
    jump = instruction_pointer_jump
    set(params.last, (params.first < params[1]) ? 1 : 0)
    move_pointer_by(jump)
  end

  def equals(params)
    jump = instruction_pointer_jump
    set(params.last, (params.first == params[1]) ? 1 : 0)
    move_pointer_by(jump)
  end

  def halt_program(params)
    @terminated = true
  end
end

