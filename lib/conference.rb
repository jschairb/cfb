class Conference < ActiveRecord::Base
  belongs_to :division
  has_many :teams
end
