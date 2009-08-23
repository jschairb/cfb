class Game < ActiveRecord::Base
  belongs_to :team
  belongs_to :opponent, :class_name => "Team"
  belongs_to :opponent_game, :class_name => "Game"

  validates_uniqueness_of :team_id, :scope => [:opponent_id, :date]
end
