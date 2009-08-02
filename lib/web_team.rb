require 'hpricot'
require 'open-uri'

class WebTeam

  attr_accessor :response, :site, :team, :year

  def initialize(year="2008",site="jhowell",team="OhioState")
    @year,@site,@team=year,site,team
    get_response
  end

  def url
    case site
      when "jhowell"
      return "http://www.jhowell.net/cf/scores/#{team}.htm"
    else
      raise InvalidWebsiteError
    end
  end

  def table_year
    (@response/"table[2]")
  end

  def table_header
    (table_year/"tr[1]")
  end

  def table_game_rows
    table_game_rows = []
    games = 0
    (table_year/"tr").each do |row|
      table_game_rows << row
    end
    return table_game_rows
  end

  def to_game_attributes
    games = []
    (table_year/"tr").each do |row|
      results = parse_table_row(row)
      games << results unless results.nil?
    end
    return games
  end

  private
  def get_response
    @response = Hpricot(open(url))
  end

  def parse_table_row(row)
    cell_count = row.children.length
    case cell_count
      when 6 
        parse_game_row(row)
      when 7 
        parse_neutral_site_game_row(row)
      when 8 
        parse_bowl_game_row(row)
      else 
        return nil
    end
  end

  def parse_game_row(row)
    game_attrs = { }
    i = 0
    %w(date home opponent result team_score opponent_score).each do |attribute|
      game_attrs[attribute.intern] = row.children[i].inner_html
      i+=1
    end
    return game_attrs
  end

  def parse_neutral_site_game_row(row)
    game_attrs = { }    
    game_attrs[:location] = row.children[6].inner_html
    game_attrs.merge(parse_game_row(row))
  end

  def parse_bowl_game_row(row)
    game_attrs = { }
    game_attrs[:note] = row.children[7].inner_html
    game_attrs[:location] = row.children[6].inner_html
    game_attrs.merge(parse_game_row(row))
  end
end
