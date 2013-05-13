class LeaguesController < ApplicationController
  # GET /leagues
  # GET /leagues.json
  def index
    @leagues = League.all.sort(:type => 1)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def sport
    @leagues = League.where(:sport => params[:id]).sort(:type => 1)

    respond_to do |format|
      format.html { render action: "index" }
    end
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    @league = League.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @league }
    end
  end

  # GET /leagues/new
  # GET /leagues/new.json
  def new
    @league = League.new
    @sports = Sport.all.map { |sport| [sport.title, sport._id.to_s] }
    @countries = Country.all.sort :title => 1
  end

  # GET /leagues/1/edit
  def edit
    @league = League.find(params[:id])
    @sports = Sport.all.map { |sport| [sport.title, sport._id.to_s] }
    @countries = Country.all.sort(:title => 1).map { |country| [country.title, country._id.to_s] }
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @league = League.new(params[:league])
    @league[:sport] = Moped::BSON::ObjectId params[:sport]
    @league[:country] = Moped::BSON::ObjectId params[:country]

    respond_to do |format|
      if @league.save
        format.html { redirect_to @league, notice: 'League was successfully created.' }
      else
        @sports = Sport.all.map { |sport| [sport.title, sport._id.to_s] }
        format.html { render action: "new" }
      end
    end
  end

  # PUT /leagues/1
  # PUT /leagues/1.json
  def update
    @league = League.find(params[:id])
    @league[:sport] = Moped::BSON::ObjectId params[:sport]
    @league[:country] = Moped::BSON::ObjectId params[:country]

    respond_to do |format|
      if @league.save
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
  def destroy
    @league = League.find(params[:id])
    @league.destroy

    respond_to do |format|
      format.html { redirect_to leagues_url }
      format.json { head :no_content }
    end
  end
end
