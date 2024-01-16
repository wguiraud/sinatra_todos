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

def error_for_list_name(list_name)
  return "List name must be between 1 and 150 characters" unless (1..150).cover? list_name.size
  return "List name must be unique" if session[:lists].any? { |list| list[:name] == list_name }
  nil
end

# Create a new list
post "/lists" do 
  list_name = params[:list_name].strip

  error = error_for_list_name(list_name)
  if error
    session[:error] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << { name: params[:list_name], todos: [] }
    session[:success] = "The new list has been created successfully"
    redirect "/lists"
  end
end

