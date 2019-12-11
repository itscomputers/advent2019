require 'test_helper'
require_relative "../lib/day11"

class TestEmergencyShipHullPainter
  def setup
    @program = Day11.new.data
  end

  def painter
    EmergencyShipHullPainter.new(@program, 0)
  end

  def test_next_output
    p = painter
    assert_empty p.computer.outputs
    assert_equal p.next_output, p.computer.output
  end

  def test_paint
    p = painter
    assert_nil p.painter.colors[p.painter.position]
    p.paint
    assert_equal p.painter.colors[p.painter.position], p.computer.output
  end
end

