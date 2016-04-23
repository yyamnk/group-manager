class StockerItemsController < ApplicationController
  before_action :set_stocker_item, only: [:show, :edit, :update, :destroy]

  # GET /stocker_items
  # GET /stocker_items.json
  def index
    @stocker_items = StockerItem.all
  end

  # GET /stocker_items/1
  # GET /stocker_items/1.json
  def show
  end

  # GET /stocker_items/new
  def new
    # 登録フォームではその年度の在庫のみを入力可能にする
    @stocker_item = StockerItem.new(
      fes_year_id: FesYear.find_by(fes_year: Time.now.year).id
    )
  end

  # GET /stocker_items/1/edit
  def edit
  end

  # POST /stocker_items
  # POST /stocker_items.json
  def create
    @stocker_item = StockerItem.new(stocker_item_params)

    respond_to do |format|
      if @stocker_item.save
        format.html { redirect_to @stocker_item, notice: 'Stocker item was successfully created.' }
        format.json { render :show, status: :created, location: @stocker_item }
      else
        format.html { render :new }
        format.json { render json: @stocker_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocker_items/1
  # PATCH/PUT /stocker_items/1.json
  def update
    respond_to do |format|
      if @stocker_item.update(stocker_item_params)
        format.html { redirect_to @stocker_item, notice: 'Stocker item was successfully updated.' }
        format.json { render :show, status: :ok, location: @stocker_item }
      else
        format.html { render :edit }
        format.json { render json: @stocker_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocker_items/1
  # DELETE /stocker_items/1.json
  def destroy
    @stocker_item.destroy
    respond_to do |format|
      format.html { redirect_to stocker_items_url, notice: 'Stocker item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stocker_item
      @stocker_item = StockerItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stocker_item_params
      params.require(:stocker_item).permit(:rental_item_id, :stocker_place_id, :num, :fes_year_id)
    end
end
