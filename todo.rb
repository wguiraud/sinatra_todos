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

# View list of lists
get "/lists" do
  @lists = session[:lists]

  erb :lists, layout: :layout
end

# Render the new list form 
get "/lists/new" do 
  erb :new_list, layout: :layout
end

# Create a new list
post "/lists" do 
  list_name = params[:list_name]
  puts list_name
  if list_name.strip.match?(/^[a-z ]{1,10}$/i)
    session[:lists] << { name: params[:list_name], todos: [] }
    session[:success] = "The list has been created"
    redirect "/lists"
  else
    session[:error] = "The list name must be between 1 and 150 characters long"
    erb :new_list, layout: :layout
  end
end

