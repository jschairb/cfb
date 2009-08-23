require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe NcaaSchedule do 
  describe "games" do 
    it "returns an array" do 
      schedule = NcaaSchedule.new
      schedule.games.should be_kind_of(Array)
    end
  end
end
