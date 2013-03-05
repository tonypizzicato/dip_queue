require 'spec_helper'

describe "leagues/index" do
  before(:each) do
    assign(:leagues, [
      stub_model(League,
        :title => "Title",
        :alias => "Alias",
        :type => 1
      ),
      stub_model(League,
        :title => "Title",
        :alias => "Alias",
        :type => 1
      )
    ])
  end

  it "renders a list of leagues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Alias".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
