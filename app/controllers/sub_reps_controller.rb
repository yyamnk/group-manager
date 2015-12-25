class SubRepsController < ApplicationController
  before_action :set_sub_rep, only: [:show, :edit, :update, :destroy]

  # GET /sub_reps
  # GET /sub_reps.json
  def index
    @sub_reps = SubRep.all
  end

  # GET /sub_reps/1
  # GET /sub_reps/1.json
  def show
  end

  # GET /sub_reps/new
  def new
    @sub_rep = SubRep.new
  end

  # GET /sub_reps/1/edit
  def edit
  end

  # POST /sub_reps
  # POST /sub_reps.json
  def create
    @sub_rep = SubRep.new(sub_rep_params)

    respond_to do |format|
      if @sub_rep.save
        format.html { redirect_to @sub_rep, notice: 'Sub rep was successfully created.' }
        format.json { render :show, status: :created, location: @sub_rep }
      else
        format.html { render :new }
        format.json { render json: @sub_rep.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_reps/1
  # PATCH/PUT /sub_reps/1.json
  def update
    respond_to do |format|
      if @sub_rep.update(sub_rep_params)
        format.html { redirect_to @sub_rep, notice: 'Sub rep was successfully updated.' }
        format.json { render :show, status: :ok, location: @sub_rep }
      else
        format.html { render :edit }
        format.json { render json: @sub_rep.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_reps/1
  # DELETE /sub_reps/1.json
  def destroy
    @sub_rep.destroy
    respond_to do |format|
      format.html { redirect_to sub_reps_url, notice: 'Sub rep was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_rep
      @sub_rep = SubRep.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_rep_params
      params.require(:sub_rep).permit(:group_id, :name_ja, :name_en, :department_id, :grade_id, :tel, :email)
    end
end
