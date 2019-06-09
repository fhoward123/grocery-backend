class ItemsController < ApplicationController
  # index route
  def index
    render json: Item.all
  end

  #show route
  def show
    render json: Item.find(params["id"])
  end

  # create route
  def create
    render json: Item.create(params["item"])
  end

  # delete route
  def delete
    render json: Item.delete(params["id"])
  end

  # update route
  def update
    render json: Item.update(params["id"], params["item"])
  end
end


# class ItemsController < ApplicationController
#   before_action :set_item, only: [:show, :update, :destroy]
#
#   # GET /items
#   def index
#     @items = Item.all
#
#     render json: @items
#   end
#
#   # GET /items/1
#   def show
#     render json: @item
#   end
#
#   # POST /items
#   def create
#     @item = Item.new(item_params)
#
#     if @item.save
#       render json: @item, status: :created, location: @item
#     else
#       render json: @item.errors, status: :unprocessable_entity
#     end
#   end
#
#   # PATCH/PUT /items/1
#   def update
#     if @item.update(item_params)
#       render json: @item
#     else
#       render json: @item.errors, status: :unprocessable_entity
#     end
#   end
#
#   # DELETE /items/1
#   def destroy
#     @item.destroy
#   end
#
#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_item
#       @item = Item.find(params[:id])
#     end
#
#     # Only allow a trusted parameter "white list" through.
#     def item_params
#       params.require(:item).permit(:grocery, :brand, :size, :quantity, :purchased)
#     end
# end
