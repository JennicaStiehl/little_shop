class ItemsController < ApplicationController
  def index
    @items = Item.where(active: true).order(name: :asc)
    @popular_items = Item.popular_items(5)
    @unpopular_items = Item.unpopular_items(5)
  end

  def show
    if params[:slug]
      @item = Item.find_by(slug: params[:slug])
    else
      @item = Item.find(params[:id])
    end
  end
end
