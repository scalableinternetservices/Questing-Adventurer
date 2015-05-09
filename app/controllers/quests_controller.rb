class QuestsController < ApplicationController
  before_action :set_quest, only: [:show, :edit, :update, :destroy, :accept, :complete]
  before_filter :authenticate_user!

  # GET /quests
  # GET /quests.json


  def index
    @quests = Quest.search(params[:search]).paginate(per_page: 5, page: params[:page]).where(adventurer: nil).where.not(questgiver: current_user)
    #@quests = Quest.all.paginate(per_page: 5, page: params[:page]).where(adventurer: nil).where.not(questgiver: current_user)
  end

  # GET /quests/1
  # GET /quests/1.json
  def show
  end

  # GET /quests/new
  def new
    @quest = Quest.new
  end

  # GET /quests/1/edit
  def edit
  end
  
  # POST /quests/accept
  def accept
    @quest.pendings.delete_all
    @quest.adventurer = User.find(params[:adventurer])
    @quest.status     = :closed
    @quest.save!

    redirect_to :back, notice: 'Pending adventurer accepted!'
  end

  # POST /quests/complete
  def complete
    puts "I'm currently working with #{@quest}"
    if params[:s] == "true"
      @quest.status = :success
    elsif params[:s] == "false"
      @quest.status = :failure
    end

    @quest.save!
    redirect_to :back, notice: 'Quest completed!'
  end

  # POST /quests
  # POST /quests.json
  def create
    @quest = Quest.new(quest_params)
    @quest.questgiver = current_user

    respond_to do |format|
      if @quest.save
        format.html { redirect_to @quest, notice: 'Quest was successfully created.' }
        format.json { render :show, status: :created, location: @quest }
      else
        format.html { render :new }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quests/1
  # PATCH/PUT /quests/1.json
  def update
    respond_to do |format|
      if @quest.update(quest_params)
        format.html { redirect_to @quest, notice: 'Quest was successfully updated.' }
        format.json { render :show, status: :ok, location: @quest }
      else
        format.html { render :edit }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quests/1
  # DELETE /quests/1.json
  def destroy
    @quest.destroy
    respond_to do |format|
      format.html { redirect_to quests_url, notice: 'Quest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quest
      @quest = Quest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quest_params
      params.require(:quest).permit(:questgiver_id, :adventurer_id, :title, :price, :description, :post_time, :expiration_time)
    end
end
