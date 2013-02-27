require 'spec_helper'

describe "tasks/new" do
  before(:each) do
    assign(:task, stub_model(Task,
      :type => 1,
      :title => "MyString",
      :desc => "MyString"
    ).as_new_record)
  end

  it "renders new task form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tasks_path, :method => "post" do
      assert_select "input#task_type", :name => "task[type]"
      assert_select "input#task_title", :name => "task[title]"
      assert_select "textarea#task_desc", :name => "task[desc]"
    end
  end
end
