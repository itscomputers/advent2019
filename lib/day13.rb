require_relative 'solver'
require_relative 'intcode_computer'

class Day13 < Solver
  def get_data
    File.read(file_name).split(',').map(&:to_i)
  end

  def run_one
    ArcadeGame.new(data).run_game.number_of_blocks
  end

  def run_two
    ArcadeGame.new(data, 2).play_game.score
  end
end

class ArcadeGame
  attr_reader :computer, :screen

  def initialize(program, coins=nil)
    program[0] = coins if coins
    @computer = IntcodeComputer.new(program: program)
    @output_number = -1
    @screen = {}
  end

  #---------------------------
  # gameplay
  #---------------------------

  def run_game
    advance until @computer.terminated
    self
  end

  def play_game
    advance_with_play until @computer.terminated
    self
  end

  def advance
    3.times { @computer.advance_to_next_output }
    *position, tile_id = @computer.outputs[-3..-1]
    @screen[position] = tile_id
  end

  def advance_with_play
    handle(next_io)
  end

  def next_io
    @computer.advance_to_next_io
  end

  def handle_input
    move_paddle
    @computer.advance
  end

  def handle_output
    @output_number = (@output_number + 1) % 3
    if @output_number == 2
      *position, tile_id = @computer.outputs[-3..-1]
      @screen[position] = tile_id
    end
  end

  def handle(io)
    handle_input if io == 'input'
    handle_output if io == 'output'
  end

  def advance_to_input
    advance_with_play until @computer.will_read?
  end

  #---------------------------
  # game status
  #---------------------------

  def score
    @screen[[-1, 0]]
  end

  def draw_tile(id)
    {
      0 => ' ',
      1 => '|',
      2 => '#',
      3 => '_',
      4 => 'o',
    }[id]
  end

  def range(idx)
    Range.new(0, @screen.keys.map { |p| p[idx] }.max)
  end

  def draw_screen
    range(1).map do |y|
      range(0).map do |x|
        draw_tile(@screen[[x, y]])
      end.join('')
    end
  end

  def display
    [''] + draw_screen + ['', "score: #{score}"]
  end

  def number_of_blocks
    @screen.values.count(2)
  end

  #---------------------------
  # paddle movement
  #---------------------------

  def move_paddle
    move_paddle_right if paddle < ball
    move_paddle_left if paddle > ball
    dont_move_paddle if paddle == ball
  end

  def paddle
    @screen.key(3).first
  end

  def ball
    @screen.key(4).first
  end

  def move_paddle_right
    @computer.default_input = 1
  end

  def move_paddle_left
    @computer.default_input = -1
  end

  def dont_move_paddle
    @computer.default_input = 0
  end
end

