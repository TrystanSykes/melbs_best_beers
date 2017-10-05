require 'sinatra'
# require 'sinatra/reloader'
require 'pry'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/brewery'
require_relative 'models/beer'
require_relative 'models/brewery_review'
require_relative 'models/beer_review'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    # 18-22 can be !!current_user
    if current_user
      true
    else
      false
    end
  end
end

get '/' do
  session[:last_page] = request.env['REQUEST_PATH']
  @beers = Beer.where('avg_rating > 0').order(avg_rating: :desc).limit(3)
  @breweries = Brewery.where('avg_rating > 0').order(avg_rating: :desc).limit(3)
  @most_beer_reviews = User.where('beer_review_count > 0').order(beer_review_count: :desc).limit(1)
  @most_brewery_reviews = User.where('brewery_review_count > 0').order(brewery_review_count: :desc).limit(1)
  erb :index
end

get '/login' do
  erb :login
end

get '/login/:id' do
  @user = User.find(params[:id])
  erb :login
end

get '/beers' do
  session[:last_page] = request.env['REQUEST_PATH']
  @beers = Beer.all.order(:brewery_id)
erb :beers
end

get '/beers/new' do
  @breweries = Brewery.all.order(:id)
erb :create_beer
end

get '/beers/:id' do
  session[:last_page] = request.env['REQUEST_PATH']
  @beer = Beer.find(params[:id])
  @reviews = BeerReview.where(beer_id: params[:id])
erb :beer_details
end

get '/breweries' do
  session[:last_page] = request.env['REQUEST_PATH']
  @breweries = Brewery.all.order(:id)
erb :breweries
end

get '/breweries/new' do
erb :create_brewery
end

get '/breweries/:id' do
  session[:last_page] = request.env['REQUEST_PATH']
  @brewery = Brewery.find(params[:id])
  @beers = Beer.where(brewery_id: params[:id])
  @reviews = BreweryReview.where(brewery_id: params[:id])
erb :brewery_details
end

get '/beer_reviews' do
  session[:last_page] = request.env['REQUEST_PATH']
  @beer_reviews = BeerReview.all.order(:id)
erb :beer_reviews
end

get '/beer_reviews/new' do
  @breweries = Brewery.all.order(:id)
  erb :create_beer_review
end

get '/beer_reviews/:id/edit' do
  @review = BeerReview.find(params[:id])
erb :beer_review_edit
end

get '/beer_reviews/delete/:id' do
  erb :beer_review_delete
end

get '/brewery_reviews' do
  session[:last_page] = request.env['REQUEST_PATH']
  @brewery_reviews = BreweryReview.all.order(:id)
erb :brewery_reviews
end

get '/brewery_reviews/new' do
  @breweries = Brewery.all.order(:id)
  erb :create_brewery_review
end

get '/brewery_reviews/:id/edit' do
  @review = BreweryReview.find(params[:id])
erb :brewery_review_edit
end

get '/brewery_reviews/delete/:id' do
  erb :brewery_review_delete
end

get '/users/new' do
  erb :create_user
end


post '/users' do
  @user = User.new(username: params[:username],email: params[:email], password: params[:password])
  if @user.save
    redirect "/login/#{@user.id}"
  else
    @errors = @user.errors.messages
    erb :create_user
  end
end

post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "#{session[:last_page]}"
  else
    @message = 'Incorrect email or password'
    erb :login
  end 
end

delete '/session' do
  session[:user_id] = nil
  redirect "#{session[:last_page]}"
end

post '/beers' do
  @beer = Beer.new(name: params[:beer_name],brewery_id: params[:brewery].to_i, style: params[:style], abv: params[:abv], ibu: params[:ibu], image: params[:image])
  if @beer.save
    redirect "/beers/#{@beer.id}"
  else
    @errors = @beer.errors.messages
    @breweries = Brewery.all.order(:id)
    erb :create_beer
  end
end

post '/breweries' do
  @brewery = Brewery.new(name: params[:brewery_name], address: params[:address], bar_address: params[:bar_address], website: params[:website], logo: params[:logo])
  if @brewery.save
  redirect "/breweries/#{@brewery.id}"
  else
    @errors = @brewery.errors.messages
    erb :create_brewery
  end
end

put '/brewery_reviews/:id' do
  @brewery_review = BreweryReview.find(params[:id])
  @brewery_review.body = params[:body]
  @brewery_review.rating = params[:rating]
  @brewery = @brewery_review.brewery
  if @brewery_review.save
    @reviews = @brewery.brewery_reviews
    @brewery.avg_rating = (@reviews.sum(&:rating).to_f / @reviews.count).round
    @brewery.save
    redirect "/brewery_reviews"
  else
    @errors = @brewery_review.errors.messages
    @review = BreweryReview.find(params[:id])
    erb :brewery_review_edit
  end
end

put '/beer_reviews/:id' do
  @beer_review = BeerReview.find(params[:id])
  @beer_review.body = params[:body]
  @beer_review.rating = params[:rating]
  @beer = @beer_review.beer
  if @beer_review.save
    @reviews = @beer.beer_reviews
    @beer.avg_rating = (@reviews.sum(&:rating).to_f / @reviews.count).round
    @beer.save
    redirect "/beer_reviews"
  else
    @errors = @beer_review.errors.messages
    @review = BeerReview.find(params[:id])
    erb :beer_review_edit
  end
end

delete '/beer_reviews/:id' do
  redirect '/login' unless logged_in?
  @review = BeerReview.find(params[:id])
  @review.destroy
  redirect "/beer_reviews"
end

delete '/brewery_reviews/:id' do
  redirect '/login' unless logged_in?
  @review = BreweryReview.find(params[:id])
  @review.destroy
  redirect "/brewery_reviews"
end

post '/beer_reviews' do
  @beer = Beer.find(params[:beer_reviewed])
  @user = User.find(session[:user_id])
  @beer_review = BeerReview.new(user_id: session[:user_id], beer: @beer, body: params[:body], rating: params[:rating])
  if @beer_review.save
    @reviews = @beer.beer_reviews
    @beer.avg_rating = (@reviews.sum(&:rating).to_f / @reviews.count).round
    @beer.save
    @user.beer_review_count = BeerReview.where(user_id: @user.id).count
    @user.save(validate: false)
    redirect "/beers/#{@beer.id}"
  else
    @breweries = Brewery.all.order(:id)
    @errors = @beer_review.errors.messages
    erb :create_beer_review
  end
end

post '/brewery_reviews' do
  @brewery = Brewery.find(params[:brewery_reviewed])
  @user = User.find(session[:user_id])
  @brewery_review = BreweryReview.new(user_id: session[:user_id], brewery_id: @brewery.id, body: params[:body], rating: params[:rating])
  if @brewery_review.save
    @reviews = @brewery.brewery_reviews
    @brewery.avg_rating = (@reviews.sum(&:rating).to_f / @reviews.count).round
    @brewery.save
    @user.brewery_review_count = BreweryReview.where(user_id: @user.id).count
    @user.save(validate: false)
    redirect "/breweries/#{@brewery.id}"
  else
    @breweries = Brewery.all.order(:id)
    @errors = @brewery_review.errors.messages
    erb :create_brewery_review
  end
end

