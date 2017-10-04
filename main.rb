require 'sinatra'
require 'sinatra/reloader'
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
  erb :index
end

get '/login' do
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

get '/brewery_reviews' do
  session[:last_page] = request.env['REQUEST_PATH']
  @brewery_reviews = BreweryReview.all.order(:id)
erb :brewery_reviews
end

get '/brewery_reviews/new' do
  @breweries = Brewery.all.order(:id)
  erb :create_brewery_review
end

get '/users/new' do
  erb :create_user
end

post '/users' do
  @user = User.new(username: params[:username],email: params[:email], password: params[:password])
  if @user.save
    redirect "#{session[:last_page]}"
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

post '/beer_reviews' do
  @beer = Beer.find(params[:beer_reviewed])
  @beer_review = BeerReview.new(user_id: session[:user_id], beer: @beer, body: params[:body], rating: params[:rating])
  if @beer_review.save
    @reviews = @beer.beer_reviews
    @beer.avg_rating = (@reviews.sum(&:rating).to_f / @reviews.count).round
    @beer.save
    redirect "/beers/#{@beer.id}"
  else
    @breweries = Brewery.all.order(:id)
    @errors = @beer_review.errors.messages
    erb :create_beer_review
  end
end

post '/brewery_reviews' do
  @brewery = Brewery.find(params[:brewery_reviewed])
  @brewery_review = BreweryReview.new(user_id: session[:user_id], brewery_id: @brewery.id, body: params[:body], rating: params[:rating])
  if @brewery_review.save
    @reviews = @brewery.brewery_reviews
    @brewery.avg_rating = (@reviews.sum(&:rating).to_f / @reviews.count).round
    @brewery.save
    redirect "/breweries/#{@brewery.id}"
  else
    @breweries = Brewery.all.order(:id)
    @errors = @brewery_review.errors.messages
    erb :create_brewery_review
  end
end

