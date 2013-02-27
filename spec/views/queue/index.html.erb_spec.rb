require 'spec_helper'

describe "queue/index.html.erb" do

  it "renders a queue status" do
    render

    rendered.should include("Queue monitor")
    #unless Daemons::Rails::Monitoring.controller("queue.rb").nil?
    #  rendered.should_not include("No queue service found")
    #  assert_select "a.button", :text => "Stop"
    #  assert_select "a.button", :text => "Start"
    #end
  end
end
