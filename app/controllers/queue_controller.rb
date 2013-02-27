class QueueController < ApplicationController
  def index
    @queue = Daemons::Rails::Monitoring.controller("queue.rb")
  end

  def start
    Daemons::Rails::Monitoring.start("queue.rb")
    redirect_to queue_path
  end

  def stop
    Daemons::Rails::Monitoring.stop("queue.rb")
    redirect_to queue_path
  end
end
