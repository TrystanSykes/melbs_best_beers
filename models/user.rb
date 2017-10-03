class User < ActiveRecord::Base
  has_many :beer_reviews
  has_many :brewery_reviews
  has_secure_password
end