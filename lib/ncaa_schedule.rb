#!/usr/bin/env ruby
require 'rubygems'
require 'net/https'
require 'hpricot'
require 'chronic'
class NcaaSchedule

  attr_accessor :url, :year, :team_id, :games

  def initialize(team_name="University of Florida", team_id="235", year=Time.now.year)
    @url = "https://goomer.ncaa.org/reports/rwservlet?hidden_run_parameters=p_mfb_schrec&p_sport_code=MFB&v_year=#{year}&p_orgnum=#{team_id}"
    setup_server
    get_response
    parse_response
  end

  private
  def setup_server
    uri = URI.parse(@url)
    @server = Net::HTTP.new uri.host, uri.port
    @server.use_ssl = uri.scheme == 'https'
    @server.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  def get_response
    @response = @server.get(@url)
    @doc = Hpricot(@response.body)
  end

  def parse_response
    @rows = @doc.search("tr")
    @rows.delete_if { |row| row.children.length != 31 }
    # 3 7 11 15 19 27
    @games = []
    @rows.each do |row|
      game = { :opponent       => parse_element(row.children[3]),
               :neutral        => parse_neutral(row.children[7]),
               :date           => parse_date(row.children[11]),
               :score_team     => parse_element(row.children[19]),
               :score_opponent => parse_element(row.children[27]),
               :result         => parse_result(row.children[15]),
               :home           => parse_home(row.children[7]),
        :location       => parse_location(row.children[7])}
      @games << game
    end
  end

  def parse_element(element)
    (element/"font").inner_html.gsub("&nbsp;", " ").gsub("&amp;", "&").strip
  end

  def parse_home(site_element)
    loc = parse_element(site_element)
    loc == "HOME" ? true : false
  end

  def parse_location(site_element)
    loc = parse_element(site_element)
  end

  def parse_neutral(site_element)
    loc = parse_element(site_element)
    case loc
      when "HOME"
        false
      when "AWAY"
        false
      else
        true
    end
  end

  def parse_result(site_element)
    result = parse_element(site_element)
    result[0,1]
  end

  def parse_date(date_element)
    date = parse_element(date_element)
    time = Chronic.parse(date.gsub(",", "").gsub(".", "").downcase)
    Date.new(time.year, time.month, time.day)
  end
  
end

