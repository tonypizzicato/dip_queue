require 'spec_helper'

describe "home/index.html.erb" do
  it "has logo" do
    render
    rendered.should include("Home#")
  end
end
