class Brewery < ActiveRecord::Base
  has_many :beers
  has_many :brewery_reviews

  validates :name, presence: true
  validates :address, presence: true
  validates :website, presence: true, length: { minimum: 15 }
  validates :logo, presence: true, length: { minimum: 15 }
end