require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do 
  session[:lists] ||= []
end

get "/" do 
  redirect "/lists"
end

configure do 
  enable :sessions
  set :session_secret, SecureRandom.hex(32) 
end

get "/lists" do
  @lists = session[:lists]

  erb :lists, layout: :layout
end

