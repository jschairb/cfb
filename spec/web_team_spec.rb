require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'hpricot'

describe WebTeam do 

  before(:all) do 
    FakeWeb.register_uri(:get, "http://www.jhowell.net/cf/scores/OhioState.htm", 
      :body => File.read(File.expand_path(File.dirname(__FILE__) + '/fixtures/mocks/OhioState.htm')))
    @web_team = WebTeam.new("2008", "jhowell", "OhioState")
  end

  it "can be passed a year" do 
    WebTeam.new("2009").year.should == "2009"
  end

  it "sets the year to 2008 by default" do 
    WebTeam.new.year.should == "2008"
  end

  it "sets the site to jhowell by default" do 
    WebTeam.new.site.should == "jhowell"
  end

  it "sets the team to OhioState by default" do 
    WebTeam.new.team.should == "OhioState"
  end

  describe "when parsing jhowell.net" do 
    before(:all) do 
      @response = Hpricot(open(File.expand_path(File.dirname(__FILE__) + '/fixtures/mocks/OhioState.htm')))
    end
  
    it "returns the proper url for jhowell.net team page" do 
      @web_team.url.should == "http://www.jhowell.net/cf/scores/OhioState.htm"
    end

    describe "when parsing a single team page" do 
      it "finds the 2nd table for the default(2008) season" do 
        @web_team.table_year.inner_html.should == (@response/"table[2]").inner_html
      end
        
      describe "when parsing a season table" do 
        before(:all) { @table = (@response/"table[2]") }
        it "finds the header row" do 
          @web_team.table_header.inner_html.should == (@table/"tr[1]").inner_html
        end
  
        it "returns an array of Game objects"

        describe "when parsing a game line" do 
          before(:all) do 
            @line = (@table/"tr[2]")
          end

          describe "when parsing a bowl game line" do 
            it "has additional table cells"
            it "populates the location field"
            it "populates the note field"
          end
        end
      end
    end
  end
end
