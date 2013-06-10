require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :host => 'localhost',
  :username => 'Gabriel',
  :password => '',
  :database => 'potluckplanner',
  :encoding => 'utf8'
)
## remember to connect to the right database

require_relative "item"
require_relative "person"
require_relative "tag"
require_relative "potluck"
require_relative "helpers/form_helpers"
## require relatives for the classes your classes with inherited from active record
get "/" do
  @potlucks = Potluck.all
  erb :index
end
## when we recieve a get request to new_potluck, erb to new_potluck
get "/new_potluck" do
  erb :new_potluck
end

#Add(save) new potluck to the table

post "/new_potluck" do
  @potluck = Potluck.new(:name => params[:potluck_name])
  ##:potluck_name param is what we set as the name of the html form in new_potluck.erb
  if @potluck.save
    redirect "/"
  else
    erb :new_potluck
  end
end
## if it saves redirect to the index, otherwise stay on the new_potluck page.

#Once potluck is added make sure you can see the potlucks on the index.erb page
#Once functionality is set up to display your potluck name data, also set up a button to edit it.

get "/view_potluck/:potluck_id" do
    @potluck = Potluck.find_by_id(params[:potluck_id])
    @items = Item.all
    @people = Person.all
    @person = Person.find_by_id(params[:person_id])
    @tags = Tag.all
    @item = Item.find_by_id(params[:potluck_id])
    @tag = Tag.find_by_id(params[:tag_id])
    erb :view_potluck
end
##This page is to view all the details of the potluck incl items and people bringing what. The param is passed from the index page.

#Create new item stand alone
get "/new_item" do
  @potluck = Potluck.find_by_id(params[:potluck_id])
  erb :new_item
end
##Form for bringing new items for a given potluck.
post "/save_item" do
  @item = Item.new(params[:item])
  if @item.save
    @potluck = Potluck.find_or_create_by_name(params[:potluck][:name])
    ## repeat the AR magic for person name
    @person = Person.find_or_create_by_name(params[:person][:name])
    ##update item table with the  id from both
    @item.update_attributes(:potluck_id => @potluck.id, :person_id => @person.id)

    redirect to ("/view_potluck/"+@potluck.id.to_s)
  else
    erb :new_item
  end
end


## This post is for when you are viewing a particular potluck with particular info. Should take you to another page where you can edit the information that is already in the fields.
get "/edit_item/:item_id/:potluck_id/:person_id" do
 @potluck = Potluck.find_by_id(params[:potluck_id])
 @person = Person.find_by_id(params[:person_id])
 @item = Item.find_by_id(params[:item_id])
 @tag = Tag.find_by_id(params[:tag_id])
  erb :edit_item
end

get "/edit_item/:item_id/:potluck_id/" do
  @potluck = Potluck.find_by_id(params[:potluck_id])
  @person = Person.find_by_id(params[:person_id])
  @item = Item.find_by_id(params[:item_id])
  @tag = Tag.find_by_id(params[:tag_id])
   erb :edit_item
 end
## If editing, can update items
post "/update_item" do
  @item = Item.new(params[:item])
  if @item.save
    @potluck = Potluck.find_or_create_by_name(params[:potluck][:name])
    ## repeat the AR magic for person name
    @person = Person.find_or_create_by_name(params[:person][:name])
    ##update item table with the  id from both
    @item.update_attributes(:potluck_id => @potluck.id, :person_id => @person.id)

    redirect to ("/view_potluck/"+@potluck.id.to_s)
  else
    erb :new_item
  end
end

post "/save_item/:item_id" do
    @item = Item.find_by_id(params[:item_id])
    @person = Person.find_by_id(params[:person_id])
    if @item.update_attributes(params[:item])
      redirect "/"
    else
      erb :edit_item
    end
  end

  ## Here comes the tags.
get "/new_tag" do
  erb :new_tag
end

post "/new_tag" do
  @tag = Tag.new(:name => params[:tag_name])
  if @tag.save
    redirect "/"
  else
    erb :new_tag
  end
end

get "/new_person" do
  erb :new_person
end

post "/new_person" do
  @person = Person.new(:name => params[:person_name])
  if @person.save
    redirect "/"
  else
    erb :new_person
  end
end
## Have to make a new person and link the id to the items table