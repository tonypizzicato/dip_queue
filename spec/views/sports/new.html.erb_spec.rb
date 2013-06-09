require 'spec_helper'

describe "sports/new" do
  before(:each) do
    assign(:sport, stub_model(Sport,
      :type => 1,
      :title => "MyString"
    ).as_new_record)
  end

  it "renders new sport form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", sports_path, "post" do
      assert_select "input#sport_type[name=?]", "sport[type]"
      assert_select "input#sport_title[name=?]", "sport[title]"
    end
  end
end
