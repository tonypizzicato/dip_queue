require 'spec_helper'

describe "sports/show" do
  before(:each) do
    @sport = assign(:sport, stub_model(Sport,
      :type => 1,
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Title/)
  end
end
