require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Division do 
  it "should be a division" do 
    Division.new.should be_kind_of(Division)
  end

  it "should create" do 
    Division.create.should_not be_new_record
  end
  
  it "should be valid" do 
    Division.new.should be_valid
  end
end
