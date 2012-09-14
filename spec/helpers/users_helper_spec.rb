# encoding: UTF-8
require "spec_helper"

#ApplicationController.helpers.gravatar_for(user)

describe UsersHelper do

  let(:user)     { FactoryGirl.create(:user) }
  let (:gravatar){ gravatar_for(user)}

  describe "gravatar" do

      it "should have image tag" do
        gravatar.should have_selector("img", :count => 1)
      end

      it "should have user name" do
        gravatar.should =~ /#{user.name}/
      end

      it "should have gravatar class" do
        gravatar.should =~ /gravatar/
      end

  end

end