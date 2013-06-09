require 'spec_helper'

describe "leagues/new" do
  before(:each) do
    assign(:league, stub_model(League,
      :title => "MyString",
      :alias => "MyString",
      :type => 1
    ).as_new_record)
  end

  it "renders new league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", leagues_path, "post" do
      assert_select "input#league_title[name=?]", "league[title]"
      assert_select "input#league_alias[name=?]", "league[alias]"
      assert_select "input#league_type[name=?]", "league[type]"
    end
  end
end
