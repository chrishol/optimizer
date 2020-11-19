class ProjectionSet < ApplicationRecord
  belongs_to :gameweek

  validates_presence_of :source
end
