class RentableItemsController < ApplicationController
  before_action :set_rentable_item, only: [:show, :edit, :update, :destroy]

  # GET /rentable_items
  # GET /rentable_items.json
  def index
    @rentable_items = RentableItem.all
  end

  # GET /rentable_items/1
  # GET /rentable_items/1.json
  def show
  end

  # GET /rentable_items/new
  def new
    @rentable_item = RentableItem.new
  end

  # GET /rentable_items/1/edit
  def edit
  end

  # POST /rentable_items
  # POST /rentable_items.json
  def create
    @rentable_item = RentableItem.new(rentable_item_params)

    respond_to do |format|
      if @rentable_item.save
        format.html { redirect_to @rentable_item, notice: 'Rentable item was successfully created.' }
        format.json { render :show, status: :created, location: @rentable_item }
      else
        format.html { render :new }
        format.json { render json: @rentable_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rentable_items/1
  # PATCH/PUT /rentable_items/1.json
  def update
    respond_to do |format|
      if @rentable_item.update(rentable_item_params)
        format.html { redirect_to @rentable_item, notice: 'Rentable item was successfully updated.' }
        format.json { render :show, status: :ok, location: @rentable_item }
      else
        format.html { render :edit }
        format.json { render json: @rentable_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rentable_items/1
  # DELETE /rentable_items/1.json
  def destroy
    @rentable_item.destroy
    respond_to do |format|
      format.html { redirect_to rentable_items_url, notice: 'Rentable item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rentable_item
      @rentable_item = RentableItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rentable_item_params
      params.require(:rentable_item).permit(:stocker_item_id, :stocker_place_id, :max_num)
    end
end
