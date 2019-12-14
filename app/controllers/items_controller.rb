class ItemsController < ApplicationController

  get "/items" do
    redirect_if_not_logged_in
      @items = Item.all
      erb :'items/index'
  end

  get "/items/new" do
    redirect_if_not_logged_in
    @error_message = params[:error]
    erb :'items/new'
  end

  get "/items/:id/edit" do
    redirect_if_not_logged_in
    @error_message = params[:error]
    @item = Item.find(params[:id])
    erb :'items/edit'
  end

  post "/items/:id" do
    redirect_if_not_logged_in
    @item = Item.find_by_id(params[:id])
    unless Item.valid_params?(params)
      redirect to "/items/#{@item.id}/edit?error=invalid item"
    end
    @item.update(params.select{ |key| key == "name" || key == "cornucopias_id"} )
    redirect "/items/#{@item.id}"
  end

  get "/items/:id" do
    redirect_if_not_logged_in
    @item = Item.find_by_id(params[:id])
    erb :'/items/show'
  end

  post "/items" do
    redirect_if_not_logged_in
    unless Item.valid_params?(params)
        redirect "/itmes/new?error=invalid item"
    end
    Item.create(params)
    redirect "/items"
  end

  delete "/items/:id/delete" do
    redirect_if_not_logged_in
    @item = Item.find_by_id(params[:id])
    if @item && @item.user == current_user
      @item.delete
      redirect to '/items'
    else
      redirect to '/login'
    end
  end

end
