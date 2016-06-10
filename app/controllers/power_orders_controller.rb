class PowerOrdersController < GroupBase
  before_action :set_power_order, only: [:show, :edit, :update, :destroy]
  before_action :set_groups # カレントユーザの所有する団体を@groupsとする
  load_and_authorize_resource # for cancancan

  # GET /power_orders
  # GET /power_orders.json
  def index
    @power_orders = []
    # 所有する団体のみで絞り込み
    @groups.each { |group|
      get_orders = PowerOrder.where( group_id: group.id )
      @power_orders = @power_orders + get_orders
    }
  end

  # GET /power_orders/1
  # GET /power_orders/1.json
  def show
  end

  # GET /power_orders/new
  def new
    @power_order = PowerOrder.new
  end

  # GET /power_orders/1/edit
  def edit
  end

  # POST /power_orders
  # POST /power_orders.json
  def create
    @power_order = PowerOrder.new(power_order_params)

    respond_to do |format|
      if @power_order.save
        format.html { redirect_to @power_order, notice: 'Power order was successfully created.' }
        format.json { render :show, status: :created, location: @power_order }
      else
        format.html { render :new }
        format.json { render json: @power_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /power_orders/1
  # PATCH/PUT /power_orders/1.json
  def update
    respond_to do |format|
      if @power_order.update(power_order_params)
        format.html { redirect_to @power_order, notice: 'Power order was successfully updated.' }
        format.json { render :show, status: :ok, location: @power_order }
      else
        format.html { render :edit }
        format.json { render json: @power_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /power_orders/1
  # DELETE /power_orders/1.json
  def destroy
    @power_order.destroy
    respond_to do |format|
      format.html { redirect_to power_orders_url, notice: 'Power order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_power_order
      @power_order = PowerOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def power_order_params
      params.require(:power_order).permit(:group_id, :item, :power, :manufacturer, :model)
    end

    def set_groups
      super  # set @groups by GroupBase.get_groups
      # 自分の所有するグループでステージ以外
      @groups = @groups.where( group_category_id: [1,2,3,4,5] )
    end
end
