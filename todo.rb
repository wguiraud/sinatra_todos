require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do 
  redirect "/lists"
end

get "/lists" do
  @lists = [
    {name: "Lunch Groceries", :todos => ["bread", "water"]}, 
    {name: "Dinner Groceries", :todos => ["wine", "lavander"]}
  ]

  erb :lists, layout: :layout
end

