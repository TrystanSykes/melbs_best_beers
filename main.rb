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
  @beers = Beer.all
erb :beers
end

get '/beers/create' do
  @breweries = Brewery.all
erb :create_beer
end

get '/beers/:id' do
  session[:last_page] = request.env['REQUEST_PATH']
  @beer = Beer.find(params[:id])
  @reviews = Beer_review.where(beer_id: params[:id])
erb :beer_details
end

get '/breweries' do
  session[:last_page] = request.env['REQUEST_PATH']
  @breweries = Brewery.all
erb :breweries
end

get '/breweries/create' do
erb :create_brewery
end

get '/breweries/:id' do
  session[:last_page] = request.env['REQUEST_PATH']
  @brewery = Brewery.find(params[:id])
  @beers = Beer.where(brewery_id: params[:id])
  @reviews = Brewery_review.where(brewery_id: params[:id])
erb :brewery_details
end

get '/beer_reviews' do
  session[:last_page] = request.env['REQUEST_PATH']
  @beer_reviews = Beer_review.all
erb :beer_reviews
end

get '/brewery_reviews' do
  session[:last_page] = request.env['REQUEST_PATH']
  @brewery_reviews = Brewery_review.all
erb :brewery_reviews
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
    @breweries = Brewery.all
# binding.pry
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