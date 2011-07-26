class CompetitorPrice < ActiveRecord::Base
  belongs_to :variant
  belongs_to :competitor
end