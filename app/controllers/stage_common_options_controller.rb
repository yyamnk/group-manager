class StageCommonOptionsController < GroupBase
  before_action :set_stage_common_option, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource # for cancancan

  # GET /stage_common_options
  # GET /stage_common_options.json
  def index
    @stage_common_options = StageCommonOption.where(group_id: @groups)
  end

  # GET /stage_common_options/1
  # GET /stage_common_options/1.json
  def show
  end

  # GET /stage_common_options/new
  def new
    @stage_common_option = StageCommonOption.new
  end

  # GET /stage_common_options/1/edit
  def edit
  end

  # POST /stage_common_options
  # POST /stage_common_options.json
  def create
    @stage_common_option = StageCommonOption.new(stage_common_option_params)

    respond_to do |format|
      if @stage_common_option.save
        format.html { redirect_to @stage_common_option, notice: 'Stage common option was successfully created.' }
        format.json { render :show, status: :created, location: @stage_common_option }
      else
        format.html { render :new }
        format.json { render json: @stage_common_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stage_common_options/1
  # PATCH/PUT /stage_common_options/1.json
  def update
    respond_to do |format|
      if @stage_common_option.update(stage_common_option_params)
        format.html { redirect_to @stage_common_option, notice: 'Stage common option was successfully updated.' }
        format.json { render :show, status: :ok, location: @stage_common_option }
      else
        format.html { render :edit }
        format.json { render json: @stage_common_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stage_common_options/1
  # DELETE /stage_common_options/1.json
  def destroy
    @stage_common_option.destroy
    respond_to do |format|
      format.html { redirect_to stage_common_options_url, notice: 'Stage common option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stage_common_option
      @stage_common_option = StageCommonOption.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stage_common_option_params
      params.require(:stage_common_option).permit(:group_id, :own_equipment, :bgm, :camera_permittion, :loud_sound, :stage_content)
    end
end
