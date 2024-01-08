require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @lists = [
    {name: "Lunch Groceries" }, 
    {name: "Dinner Groceries" }
  ]
  erb "You have no lists.", layout: :layout
end
