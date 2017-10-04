class BeerReview < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer
  validates :body, presence: true, length: { maximum: 1000 }
  validates :rating, presence: true, length: { maximum: 1 }

  before_save :filter_rating
  
  def filter_rating
    self.rating = self.rating.to_i
  end
end
