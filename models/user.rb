class User < ActiveRecord::Base
  has_many :beer_reviews
  has_many :brewery_reviews

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password
end