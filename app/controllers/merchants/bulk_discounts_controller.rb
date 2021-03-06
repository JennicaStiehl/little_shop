class Merchants::BulkDiscountsController < ApplicationController

  def index
    @item = Item.find_by(slug: params[:item_slug])
  end

  def show
    if params[:item_id]
      @item = Item.find_by(slug: params[:item_id])
    elsif params[:item_id] == nil
      Item.find_nil_slugs
      @item = Item.find_by(slug: params[:item_id])
    else
      @item = Item.find(params[:item_id])
    end
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @discount = BulkDiscount.new
    @item = Item.find(params[:item_slug])
  end

  def create
    bulk_discount = BulkDiscount.new(discount: discount_params[:discount],
    threshold: discount_params[:threshold], item_id: discount_params[:item_id])
    if bulk_discount.save
      redirect_to items_path
    else
      render :new
    end
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
    if params[:slug]
      @item = Item.find_by(slug: params[:slug])
    else
      @item = Item.find(params[:item_slug])
    end
  end

  def update
    @discount = BulkDiscount.find(params[:id])
    @item = Item.find(params[:bulk_discount][:item_id])
    @discount.update(discount: update_params[:discount], threshold: update_params[:threshold])
    if @discount.save
      redirect_to items_path
      flash[:success] = "Your item has been updated."
    else
      render :edit
    end
  end

  def destroy
    bd = BulkDiscount.find(params[:id])
    if bd && current_merchant?
      bd.destroy
      redirect_to items_path
    else
      render file: 'public/404', status: 404
    end
  end


  private
  def discount_params
    params.require(:bulk_discount).permit(:discount, :threshold, :discount_type, :item_id)
  end

  def update_params
    params.require(:bulk_discount).permit(:discount, :threshold)
  end
end
