require './spec_helper.rb'
require './destroyer.rb'

describe Destroyer do
  describe "bitmaps" do
    it "should calculate a laser in 0 position = bitmap 1" do
      subject.add_laser(0, 0).should == 1
    end

    it "should calculate a laser in 1 position = bitmap 2" do
      subject.add_laser(0, 1).should == 2
    end

    it "should calculate a laser in 2 position = bitmap 4" do
      subject.add_laser(0, 2).should == 4
    end

    it "should add new positions to non-0 bitmaps" do
      subject.add_laser(1, 1).should == 3   #00011
      subject.add_laser(3, 2).should == 7   #00111
      subject.add_laser(7, 4).should == 23  #10111
    end

    it "should determine if a laser is in a given position in a bitmap" do
      bitmap = 213 #11010101=1+4+16+64+128=213
      subject.has_laser?(bitmap, 0).should be_true
      subject.has_laser?(bitmap, 1).should be_false
      subject.has_laser?(bitmap, 2).should be_true
      subject.has_laser?(bitmap, 3).should be_false
      subject.has_laser?(bitmap, 4).should be_true
      subject.has_laser?(bitmap, 5).should be_false
      subject.has_laser?(bitmap, 6).should be_true
      subject.has_laser?(bitmap, 7).should be_true
    end
  end
end

