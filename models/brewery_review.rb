class Brewery_review < ActiveRecord::Base
  belongs_to :user
  belongs_to :brewery
end