require 'spec_helper'

describe "tasks/index" do
  before(:each) do
    assign(:tasks, [
      stub_model(Task,
        :type => 1,
        :title => "Title",
        :desc => "Desc"
      ),
      stub_model(Task,
        :type => 1,
        :title => "Title",
        :desc => "Desc"
      )
    ])
  end

  it "renders a list of tasks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Desc".to_s, :count => 2
  end
end
