require 'spec_helper'

describe "leagues/edit" do
  before(:each) do
    @league = assign(:league, stub_model(League,
      :title => "MyString",
      :alias => "MyString",
      :type => 1
    ))
  end

  it "renders the edit league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", league_path(@league), "post" do
      assert_select "input#league_title[name=?]", "league[title]"
      assert_select "input#league_alias[name=?]", "league[alias]"
      assert_select "input#league_type[name=?]", "league[type]"
    end
  end
end
