class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :beer_reviews

  validates :name, presence: true
  validates :abv, presence: true
  validates :image, presence: true, length: { minimum: 20 }
  # errors.add(:name, "must be present!")
end