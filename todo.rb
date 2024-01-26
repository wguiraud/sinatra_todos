# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
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

# return an error message if the name is invalid. Return nil if name is valid
def error_for_list_name(name)
  #return "List name must be between 1 and 150 characters" unless (1..150).cover? name.size
  return "List name must be between 1 and 150 alphabetic characters" unless name.match?(/^[\w ]{1,150}$/) 
  return "List name must be unique" if session[:lists].any? { |list| list[:name] == name }

  nil
end

# return an error message if the name is invalid. Return nil otherwise 
def error_for_todo_name(todo_name)
  #return "Todo name must be between 1 and 100 characters" unless (1..150).cover? name.size
  return "The todo name must be between 1 and 100 alphabetic characters" unless todo_name.match?(/^[\w ]{1,100}$/)

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

# view the todos of one specific list 
get "/lists/:id" do 
  @list_id = params[:id].to_i
  @list = session[:lists][@list_id]
  erb :list, layout: :layout 
end

# Edit an existing Todo list
get "/lists/:id/edit" do 
  id = params[:id].to_i
  @list = session[:lists][id]
  erb :edit_list, layout: :layout
end

# Updating an existing Todo list
post "/lists/:id" do 
  list_name = params[:list_name].strip
  id = params[:id].to_i
  @list = session[:lists][id]

  error = error_for_list_name(list_name)
  if error
    session[:error] = error #unless ....list_name == @lists[:name]
    erb :edit_list, layout: :layout
  else
    @list[:name] = list_name 
    session[:success] = "The list has been renamed successfully"
    redirect "/lists/#{id}"
  end
end

# Delete a Todo list
post "/lists/:id/delete" do 
  id = params[:id].to_i
  session[:lists].delete_at(id)
  session[:success] = "The list has been successfully deleted"
  redirect "/lists"
end

# Add a new Todo to a list 
post "/lists/:list_id/todos" do 
  @params = params
	@list_id = params[:list_id].to_i
	@list = session[:lists][@list_id] #making the local variable an instance variable
	todo_name = params[:todo].strip
	
	error = error_for_todo_name(todo_name)
  if error
		session[:error] = error
		erb :list, layout: :layout
	else
		@list[:todos] << { name: todo_name, completed: false } # refactoring this line of code accordingly
		session[:success] = "The todo has been successfully added"
		redirect "/lists/#{@list_id}"
	end 
end

# Delete a Todo from a list
post "/lists/:list_id/todos/:id/delete" do
  @list_id = params[:list_id].to_i
  @list = session[:lists][@list_id]

  todo_id = params[:id].to_i

  @list[:todos].delete_at todo_id
  session[:success] = "The todo was successfully deleted"
  redirect"/lists/#{@list_id}"
end
