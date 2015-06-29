class PurchaseListsController < ApplicationController
  before_action :set_purchase_list, only: [:show, :edit, :update, :destroy]

  # GET /purchase_lists
  # GET /purchase_lists.json
  def index_fresh
    @purchase_lists = PurchaseList.all
  end

  # GET /purchase_lists/1
  # GET /purchase_lists/1.json
  def show
  end

  # GET /purchase_lists/new
  def new_fresh
    @purchase_list = PurchaseList.new( is_fresh: params[:is_fresh], fes_date_id: params[:fes_date_id])
  end

  # GET /purchase_lists/1/edit
  def edit
  end

  # POST /purchase_lists
  # POST /purchase_lists.json
  def create
    @purchase_list = PurchaseList.new(purchase_list_params)

    respond_to do |format|
      if @purchase_list.save
        format.html { redirect_to @purchase_list, notice: 'Purchase list was successfully created.' }
        format.json { render :show, status: :created, location: @purchase_list }
      else
        format.html { render :new }
        format.json { render json: @purchase_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_lists/1
  # PATCH/PUT /purchase_lists/1.json
  def update
    respond_to do |format|
      if @purchase_list.update(purchase_list_params)
        format.html { redirect_to @purchase_list, notice: 'Purchase list was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase_list }
      else
        format.html { render :edit }
        format.json { render json: @purchase_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_lists/1
  # DELETE /purchase_lists/1.json
  def destroy
    @purchase_list.destroy
    respond_to do |format|
      format.html { redirect_to purchase_lists_url, notice: 'Purchase list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_list
      @purchase_list = PurchaseList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_list_params
      params.require(:purchase_list).permit(:food_product_id, :shop_id, :fes_date_id, :is_fresh, :items)
    end
end
