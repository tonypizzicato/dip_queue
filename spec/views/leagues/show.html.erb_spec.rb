require 'spec_helper'

describe "leagues/show" do
  before(:each) do
    @league = assign(:league, stub_model(League,
      :title => "Title",
      :alias => "Alias",
      :type => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Alias/)
    rendered.should match(/1/)
  end
end
