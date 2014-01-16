require './spec_helper.rb'
require './destroyer.rb'

describe Destroyer do
  describe "bitmaps" do
    it "should add a laser in 0 position = bitmap 1" do
      subject.add_laser(0, 0).should == 1
    end

    it "should add a laser in 1 position = bitmap 2" do
      subject.add_laser(0, 1).should == 2
    end

    it "should add a laser in 2 position = bitmap 4" do
      subject.add_laser(0, 2).should == 4
    end

    it "should add new lasers to non-0 bitmaps" do
      subject.add_laser(1, 1).should == 3   # 00011
      subject.add_laser(3, 2).should == 7   # 00111
      subject.add_laser(7, 4).should == 23  # 10111
    end

    it "should determine if a laser is in a given position in a bitmap" do
      bitmap = 213 # 11010101=1+4+16+64+128=213
      subject.has_laser?(bitmap, 0).should be_true
      subject.has_laser?(bitmap, 1).should be_false
      subject.has_laser?(bitmap, 2).should be_true
      subject.has_laser?(bitmap, 3).should be_false
      subject.has_laser?(bitmap, 4).should be_true
      subject.has_laser?(bitmap, 5).should be_false
      subject.has_laser?(bitmap, 6).should be_true
      subject.has_laser?(bitmap, 7).should be_true
      subject.has_laser?(bitmap, 8).should be_false
    end
  end

  describe "parsing" do
    # Note: string position 0 is bitmap position 0. When
    # writing by hand, the left-most bit in the string would
    # correspond the right-most bit in the bitmap. Not doing
    # any right-to-left transposition of the input string.
    it "parses a laser-row char" do
      # row "|#||#" = 1+4+8 = 13
      bitmap = subject.parse_laser_char('|', 0, 0)
      bitmap = subject.parse_laser_char('#', bitmap, 1)
      bitmap = subject.parse_laser_char('|', bitmap, 2)
      bitmap = subject.parse_laser_char('|', bitmap, 3)
      bitmap = subject.parse_laser_char('#', bitmap, 4)
      bitmap.should == 13
    end

    it "parses a conveyor char" do
      subject.parse_conveyor_char('-', 0)
      subject.conveyor_length.should == 1
      subject.parse_conveyor_char('X', 1)
      subject.robot_start_idx.should == 1
      subject.conveyor_length.should == 2
      subject.parse_conveyor_char('-', 2)
      subject.conveyor_length.should == 3
    end
  end

  it "processes input chars" do
    chars = "#|#|#|\n"
    chars << "---X--\n"
    chars << "###||#"
    chars.chars.each { |c| subject.process(c) }

    subject.north_lasers.should    == 42 # 2+8+32
    subject.robot_start_idx.should == 3
    subject.conveyor_length.should == 6
    subject.south_lasers.should    == 24 # 8+16
  end

  describe "solving" do
    let(:puzzle) { %Q(#|#|#|##\n---X----\n###||###) }

    it "determines if robot is hit at a given click" do
      puzzle.chars.each { |c| subject.process(c) }
      # go west
      subject.hit?(3, 0).should be_true
      subject.hit?(2, 1).should be_false
      subject.hit?(1, 2).should be_true
      subject.hit?(0, 3).should be_false

      # go east
      subject.hit?(3, 0).should be_true
      subject.hit?(4, 1).should be_true
      subject.hit?(5, 2).should be_true
      subject.hit?(6, 3).should be_false
      subject.hit?(7, 4).should be_false
    end

    it "solves sample-input A" do
      puzzle.chars.map do |c|
        subject.process(c)
      end.last.should == "GO WEST"
    end

    it "solves sample-input B" do
      puzzle = %Q(##|#|#|#\n----X---\n###||###)
      puzzle.chars.map do |c|
        subject.process(c)
      end.last.should == "GO EAST"
    end

    it "solves sample-input C" do
      puzzle = %Q(##|#|#|#\n----X---\n###|||##)
      puzzle.chars.map do |c|
        subject.process(c)
      end.last.should == "GO WEST"
    end
  end
end

