require 'spec_helper'

describe "countries/edit" do
  before(:each) do
    @country = assign(:country, stub_model(Country,
      :title => "MyString",
      :leagues => ""
    ))
  end

  it "renders the edit country form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", country_path(@country), "post" do
      assert_select "input#country_title[name=?]", "country[title]"
      assert_select "input#country_leagues[name=?]", "country[leagues]"
    end
  end
end
