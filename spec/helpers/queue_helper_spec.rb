require 'spec_helper'

describe QueueHelper do
  helper QueueHelper

  it "should return stop queue link on running queue" do
    queue = Daemons::Rails::Monitoring.controller("queue.rb")
    queue.stub(:status) { :running }
    expect(toggle queue).to match /stop/
  end

  it "should return start queue link on stopped queue" do
    queue = Daemons::Rails::Monitoring.controller("queue.rb")
    queue.stub(:status) { :not_exists }
    expect(toggle queue).to match /start/
  end
end
