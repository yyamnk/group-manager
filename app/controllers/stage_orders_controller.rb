class StageOrdersController < ApplicationController
  before_action :set_stage_order, only: [:show, :edit, :update, :destroy]
  before_action :get_groups # カレントユーザの所有する団体を@groupsとする

  # GET /stage_orders
  # GET /stage_orders.json
  def index
    @stage_orders = StageOrder.all
  end

  # GET /stage_orders/1
  # GET /stage_orders/1.json
  def show
  end

  # GET /stage_orders/new
  def new
    @stage_order = StageOrder.new
  end

  # GET /stage_orders/1/edit
  def edit
  end

  # POST /stage_orders
  # POST /stage_orders.json
  def create
    @stage_order = StageOrder.new(stage_order_params)

    respond_to do |format|
      if @stage_order.save
        format.html { redirect_to @stage_order, notice: 'Stage order was successfully created.' }
        format.json { render :show, status: :created, location: @stage_order }
      else
        format.html { render :new }
        format.json { render json: @stage_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stage_orders/1
  # PATCH/PUT /stage_orders/1.json
  def update
    respond_to do |format|
      if @stage_order.update(stage_order_params)
        format.html { redirect_to @stage_order, notice: 'Stage order was successfully updated.' }
        format.json { render :show, status: :ok, location: @stage_order }
      else
        format.html { render :edit }
        format.json { render json: @stage_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stage_orders/1
  # DELETE /stage_orders/1.json
  def destroy
    @stage_order.destroy
    respond_to do |format|
      format.html { redirect_to stage_orders_url, notice: 'Stage order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stage_order
      @stage_order = StageOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stage_order_params
      params.require(:stage_order).permit(:group_id, :is_sunny, :fes_date_id, :stage_first, :stage_second, :time, :own_equipment, :bgm, :camera_permittion, :loud_sound)
    end

    def get_groups
      @groups = Group.where( user_id: current_user.id )
    end
end
