class QueueController < ApplicationController
  # GET /queue
  def index
    @queue = Daemons::Rails::Monitoring.controller("queue.rb")
    @tasks = TaskQueue.where(:type => Task.where(:type => 1).first).all
  end

  # GET /queue/:id
  def show
    @task = TaskQueue.find(params[:id])
    #@title = "Title" #Task.where(:type => @task.type).first.title
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /queue/new
  def new
    @task = TaskQueue.new
    @leagues = League.all.map { |league| [league.title, league._id.to_s] }

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /queue
  def create
    @task = TaskQueue.new
    @task.type = Task.where(:type => 1).first
    @task.data[:url] = params[:url]
    @task.data[:league] = Moped::BSON::ObjectId params[:league]

    respond_to do |format|
      if @task.save
        format.html { redirect_to queue_status_path, notice: 'Task was successfully added.' }
      else
        @leagues = League.all.map { |league| [league.title, league._id.to_s] }
        format.html { render action: "new" }
      end
    end
  end

  # GET /queue/:id/edit
  def edit
    @task = TaskQueue.find(params[:id])
    @leagues = League.all.map { |league| [league.title, league._id.to_s] }
  end

  # PUT /queue/:id
  def update
    @task = TaskQueue.find(params[:id])

    @task.data[:url] = params[:url]
    @task.data[:league] = Moped::BSON::ObjectId params[:league]

    respond_to do |format|
      if @task.save
        format.html { redirect_to queue_path(@task), notice: 'Task was successfully updated.' }
      else
        @leagues = League.all.map { |league| [league.title, league._id.to_s] }
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /queue/:id
  def destroy
    @task = TaskQueue.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
    end
  end

  def start
    Daemons::Rails::Monitoring.start("queue.rb")
    redirect_to queue_status_path
  end

  def stop
    Daemons::Rails::Monitoring.stop("queue.rb")
    redirect_to queue_status_path
  end
end
