class Game < ActiveRecord::Base
  belongs_to :team
  belongs_to :opponent, :class_name => "Team"
  belongs_to :opponent_game, :class_name => "Game"
  belongs_to :week
  has_one    :rating

#  validates_uniqueness_of :team_id, :scope => [:opponent_id, :date]

  def division
    opponent.present? ? opponent.division : nil
  end

  def conference_game?
    return false if opponent.nil?
    return true if team && (team.conference == opponent.conference)
  end

  def conference_points
    conference_game? ? POINT_VALUES["conferences"]["in"] : POINT_VALUES["conferences"]["out"]
  end

  def division_points
    division.present? ? POINT_VALUES["divisions"][division.abbrev] : POINT_VALUES["divisions"]["NON"]
  end

  def location_points
    return POINT_VALUES["locations"]["neutral"] if neutral?
    home? ? POINT_VALUES["locations"]["home"] : POINT_VALUES["locations"]["away"]
  end

  def to_rating
    self.build_rating({ :division_points   => self.division_points.to_i,
                        :conference_points => self.conference_points.to_i,
                        :location_points   => self.location_points.to_i })
  end
end
