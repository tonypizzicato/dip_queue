require 'spec_helper'

describe "countries/new" do
  before(:each) do
    assign(:country, stub_model(Country,
      :title => "MyString",
      :leagues => ""
    ).as_new_record)
  end

  it "renders new country form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", countries_path, "post" do
      assert_select "input#country_title[name=?]", "country[title]"
      assert_select "input#country_leagues[name=?]", "country[leagues]"
    end
  end
end
