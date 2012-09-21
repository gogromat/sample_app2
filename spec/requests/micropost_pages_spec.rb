require 'spec_helper'
require 'pp'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  #let(:micropost) { FactoryGirl.create(:micropost,user: user) }

  before { sign_in user }

  describe "micropost creation" do

    before { visit root_path }

    describe "with invalid information" do
      it "should not create micropost" do
        expect { click_button "Post"}.not_to change(Micropost, :count)
      end

      describe "error message" do
        before { click_button "Post" }
        it     { should have_content('error') }
      end
    end

    describe "with valid information" do
      before {fill_in "micropost_content", with: "Lorem ipsum" }

      it "should create a micropost" do
        expect { click_button "Post"}.to change(Micropost, :count).by(1)
      end
    end

  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end

    end
  end

  describe "users should not see delete link to other users microposts" do

    let(:second_user) { FactoryGirl.create(:user) }
    before(:all) do
      5.times { FactoryGirl.create(:micropost, user: second_user, content: "Lorem ipsum")}
      visit user_path(second_user)
    end

    it { should_not have_selector("li", text: "delete") }
    it { should_not have_link('delete') }

    after(:all) do
      second_user.microposts.delete_all
      second_user.destroy
    end
  end

end
