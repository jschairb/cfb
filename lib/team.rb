class Team < ActiveRecord::Base
  belongs_to :conference
  has_many :games
  has_many :ratings, :through => :games

  def division
    conference.present? ? conference.division : nil
  end

  def ncaa_attributes_array
    [self.ncaa_name, self.ncaa_id, "2008"]
  end
end
