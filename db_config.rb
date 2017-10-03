require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'melbs_best_beers_db'
}

ActiveRecord::Base.establish_connection(options)