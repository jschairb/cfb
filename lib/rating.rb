class Rating < ActiveRecord::Base
  belongs_to :game

  before_save :calculate_first_level_subtotal
  
  class << self

    def compute(week_no=nil)
      weeks = week_no.nil? ? Week.all : [Week.find_by_number(week_no)]
      weeks.each do |week|
        ratings = week.games.each do |game|
          rating = game.to_rating
          rating.save
        end
      end
    end
  end

  protected
  def calculate_first_level_subtotal
    self.first_level_subtotal = division_points + conference_points + location_points
  end
end
