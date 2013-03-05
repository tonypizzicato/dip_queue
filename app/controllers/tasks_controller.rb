class TasksController < ApplicationController
  # GET /tasks
  def index
    @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /tasks/1
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /tasks/1
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /tasks/1
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
    end
  end
end
