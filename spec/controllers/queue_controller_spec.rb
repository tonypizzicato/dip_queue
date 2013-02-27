require 'spec_helper'

describe QueueController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'start'" do
    it "returns http success" do
      get 'start'
      response.should redirect_to '/queue'
      Daemons::Rails::Monitoring.stop("queue.rb")
    end
  end

  describe "GET 'stop'" do
    it "returns http success" do
      Daemons::Rails::Monitoring.start("queue.rb")
      get 'stop'
      response.should redirect_to '/queue'
    end
  end
end
