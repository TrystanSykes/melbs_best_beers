class Beer_review < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer
end