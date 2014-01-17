class Destroyer
  attr_accessor :north_lasers, :south_lasers
  attr_accessor :robot_start_idx, :conveyor_length
  attr_accessor :line_idx, :char_idx

  def initialize
    @north_lasers, @south_lasers       = 0, 0
    @robot_start_idx, @conveyor_length = 0, 0
    @line_idx, @char_idx               = 0, 0
  end

  # Adds a laser in a given position to a bitmap
  def add_laser(bitmap, position)
    bitmap | (2 ** position)
  end

  # Does a laser exist in a given position in a bitmap?
  def has_laser?(bitmap, position)
    bitmap & (2 ** position) != 0
  end

  def parse_laser_char(char, bitmap, idx)
    (char == '|' ? add_laser(bitmap, idx) : bitmap)
  end

  def parse_conveyor_char(char, idx)
    @conveyor_length = idx + 1
    @robot_start_idx = idx if char == 'X'
  end

  def hit?(idx, click)
    lasers = (click % 2 == 0 ? @north_lasers : @south_lasers)
    has_laser?(lasers, idx)
  end

  def total_hits(enumerator)
    click = 0
    enumerator.inject(0) do |sum, idx|
      sum += 1 if hit?(idx, click)
      click += 1
      sum
    end
  end

  def hits_west
    total_hits(@robot_start_idx.downto(0))
  end

  def hits_east
    total_hits(@robot_start_idx.upto(@conveyor_length - 1))
  end

  def solution
    (hits_east < hits_west ? "GO EAST" : "GO WEST")
  end

  def process(char)
    if char == "\n"
      @line_idx += 1
      @char_idx = 0
      return
    end

    case @line_idx
    when 0 then @north_lasers = parse_laser_char(char, @north_lasers, @char_idx)
    when 1 then parse_conveyor_char(char, @char_idx)
    when 2 then @south_lasers = parse_laser_char(char, @south_lasers, @char_idx)
    end

    return solution if @line_idx == 2 && @char_idx == @conveyor_length - 1

    @char_idx += 1
    nil
  end
end

