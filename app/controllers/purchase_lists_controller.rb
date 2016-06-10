class PurchaseListsController < GroupBase
  before_action :set_purchase_list, only: [:show, :edit, :update, :destroy]
  before_action :set_group_ids        # 各アクション実行前に実行
  load_and_authorize_resource :except=> [:index_cooking,:index_noncooking] # for cancancan

  # GET /purchase_lists
  # GET /purchase_lists.json
  def index_cooking
    set_cooking_product_ids
    @purchase_lists = PurchaseList.where( food_product_id: @cooking_product_ids )
    @fes_dates=FesDate.get_specified_year_dates(FesYear.this_year())
  end

  def index_noncooking
    set_noncooking_product_ids
    @purchase_lists = PurchaseList.where( food_product_id: @noncooking_product_ids )
    @fes_dates=FesDate.get_specified_year_dates(FesYear.this_year())
  end

  # GET /purchase_lists/1
  # GET /purchase_lists/1.json
  def show
    # テンプレートの指定,
    # show終了時にrenderで指定したテンプレートを表示する．
    if @purchase_list.food_product.is_cooking
      render 'show_cooking'
    else
      render 'show_noncooking'
    end
  end

  # GET /purchase_lists/new_cooking
  def new_cooking
    @purchase_list = PurchaseList.new( is_fresh: params[:is_fresh], fes_date_id: params[:fes_date_id])
  end

  # GET /purchase_lists/new_noncooking
  def new_noncooking
    @purchase_list = PurchaseList.new( is_fresh: false, fes_date_id: params[:fes_date_id])
  end


  # GET /purchase_lists/1/edit
  def edit
    # テンプレートの指定
    if @purchase_list.food_product.is_cooking
      render 'edit_cooking'
    else
      render 'edit_noncooking'
    end
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
        if @purchase_list.food_product.is_cooking
          format.html { render :new_cooking }
        else
          format.html { render :new_noncooking }
        end
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
        if @purchase_list.food_product.is_cooking
          format.html { render :new_cooking }
        else
          format.html { render :new_noncooking }
        end
        format.json { render json: @purchase_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_lists/1
  # DELETE /purchase_lists/1.json
  def destroy
    # リダイレクト先の指定
    if @purchase_list.food_product.is_cooking
      redirect_action = 'index_cooking'
    else
      redirect_action = 'index_noncooking'
    end

    @purchase_list.destroy
    respond_to do |format|
      format.html { redirect_to action: redirect_action, notice: 'Purchase list was successfully destroyed.' }
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

    def set_group_ids
      # ユーザが所有し，種別が模擬店(食品販売)の団体のid
      @group_ids = @groups.where(group_category_id: 1).pluck('id')
      # logger.debug @group_ids
    end

    def set_cooking_product_ids
      @cooking_product_ids = FoodProduct.where( group_id: @group_ids).where(is_cooking: true).pluck('id')
      # logger.debug @food_product_ids
    end

    def set_noncooking_product_ids
      @noncooking_product_ids = FoodProduct.where( group_id: @group_ids).where(is_cooking: false).pluck('id')
      # logger.debug @food_product_ids
    end
end
