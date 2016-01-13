class FoodProductsController < GroupBase
  before_action :set_food_product, only: [:show, :edit, :update, :destroy]
  before_action :set_groups # 各アクションの実行前に実行
  load_and_authorize_resource # for cancancan

  # GET /food_products
  # GET /food_products.json
  def index
    @food_products = FoodProduct.where(group_id: @groups)
  end

  # GET /food_products/1
  # GET /food_products/1.json
  def show
  end

  # GET /food_products/new
  def new
    @food_product = FoodProduct.new
  end

  # GET /food_products/1/edit
  def edit
  end

  # POST /food_products
  # POST /food_products.json
  def create
    @food_product = FoodProduct.new(food_product_params)

    respond_to do |format|
      if @food_product.save
        format.html { redirect_to @food_product, notice: 'Food product was successfully created.' }
        format.json { render :show, status: :created, location: @food_product }
      else
        format.html { render :new }
        format.json { render json: @food_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /food_products/1
  # PATCH/PUT /food_products/1.json
  def update
    respond_to do |format|
      if @food_product.update(food_product_params)
        format.html { redirect_to @food_product, notice: 'Food product was successfully updated.' }
        format.json { render :show, status: :ok, location: @food_product }
      else
        format.html { render :edit }
        format.json { render json: @food_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /food_products/1
  # DELETE /food_products/1.json
  def destroy
    @food_product.destroy
    respond_to do |format|
      format.html { redirect_to food_products_url, notice: 'Food product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food_product
      @food_product = FoodProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_product_params
      params.require(:food_product).permit(:group_id, :name, :num, :is_cooking, :start)
    end

    def set_groups
      # ユーザが所有し，模擬店(食品販売)のカテゴリの団体を取得する
      super  # set @groups by GroupBase.get_groups
      @groups = @groups.where( group_category_id: 1)
    end
end
