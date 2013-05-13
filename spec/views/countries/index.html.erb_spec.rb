require 'spec_helper'

describe "countries/index" do
  before(:each) do
    assign(:countries, [
      stub_model(Country,
        :title => "Title",
        :leagues => ""
      ),
      stub_model(Country,
        :title => "Title",
        :leagues => ""
      )
    ])
  end

  it "renders a list of countries" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
