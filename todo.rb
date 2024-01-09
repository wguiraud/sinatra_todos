require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @lists = [
    {name: "Lunch Groceries", :todos => ["bread", "water"]}, 
    {name: "Dinner Groceries", :todos => ["wine", "lavander"]}
  ]

  erb :lists, layout: :layout
end

