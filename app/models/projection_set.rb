class ProjectionSet < ApplicationRecord
  belongs_to :gameweek
  has_many :projections

  validates_presence_of :source
end
