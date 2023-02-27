class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items 
    else 
      items = Item.all 
    end
    render json: items, include: :user
  end

  def show 
    item = Item.find(params[:id])
    render json: item
  end

  def create 
    user = User.find(params[:user_id])
    item = user.items.create(item_params)

    if item.persisted?
      render json: item, status: :created
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end 

  private 

  def not_found_response
    render json: { error: "Not found" }, status: :not_found
  end

end
