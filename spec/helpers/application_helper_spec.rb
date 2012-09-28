require "spec_helper"

        #fullPath in app/helpers
describe ApplicationHelper do

  #here we test ApplicationHelper full_title
  describe "full_title" do

    it "should include the page title" do
      full_title("foo").should =~ /foo/
    end

    it "should include the base title" do
       full_title("foo").should =~ /^Ruby on Rails Tutorial Sample App/
       full_title("").should    =~ /Ruby on Rails Tutorial Sample App/
    end

    it "should have include a bar for the home page" do
      full_title("").should_not   =~ /\|/
    end
  end


end