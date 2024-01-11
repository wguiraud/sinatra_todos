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

get "/lists/new" do 
  erb :new_list, layout: :layout

  #session[:lists] << { name: "New List", todos: [] }
  #redirect "/lists"
end

post "/lists" do 
  session[:lists] << { name: params[:list_name], todos: [] }
  redirect "/lists"
end

