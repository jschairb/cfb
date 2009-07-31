require 'team'
class Game
  def home_team
    Team.new
  end

  def away_team
    Team.new
  end

  def neutral?
    false
  end

  def conference?
    home_team.conference == away_team.conference
  end

  def winning_team
    home_team
  end
end
