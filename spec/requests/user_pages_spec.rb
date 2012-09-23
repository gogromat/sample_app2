require 'spec_helper'

describe "User pages" do

  #render_views
  subject { page }

  describe "index" do

     let(:user) { FactoryGirl.create(:user) }

     before(:each) do
       sign_in user
       visit users_path
     end


     #before do
     #  sign_in FactoryGirl.create(:user)
     #  FactoryGirl.create(:user, name: "Bob White",    email: "white@kicks.com")
     #  FactoryGirl.create(:user, name: "Someone Else", email: "someone@Else.melbourne.com")
     #  visit users_path
     #end

    it { should have_selector('title',  text: 'All users')}
    it { should have_selector('h1',     text: 'All users')}

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user)}}
       after(:all) { User.delete_all }

      it { should have_selector('div.pagination')}

      it 'should list each user' do
        #User.all.each do |user|
        User.paginate(page: 1, limit: 20).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end

    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }

        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }

        it "should be able to delete another user" do
          expect { click_link('delete')}.to change(User, :count).by(-1)
        end

        # admin should not delete himself... Duh!
        it { should_not have_link('delete', href: user_path(admin)) }

        describe "tries to delete himself" do
          before { delete user_path(admin) }
          specify { response.should redirect_to(users_url)}
        end

      end

    end

  end

  describe "signup page" do
    before { visit signup_path }
    it     { should have_selector('h1',    text: 'Sign up') }
    it     { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user)}
    let!(:m1)  { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2)  { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it     { should have_selector("h1",    text: user.name)}
    it     { should have_selector("title", text: user.name)}

    describe "micropost" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end



    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }

      before { sign_in user }



      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment other user's count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling a button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling a button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end

      end

    end



  end

  describe "signup" do
    before { visit signup_path }

    let(:submit) { "Save" }

    describe "with invalid information" do

      it "should not create user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content( 'error') }
      end


    end

    describe "with valid information" do
      before { valid_signup }

      it "should create user" do
        expect { click_button submit }.to  change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email("user@example.com")}

        it { should have_selector('title',                  text: user.name)}
        it { should have_selector('div.alert.alert-success',title: 'Welcome')}

        it { should have_link('Sign out')}
      end
    end

  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change',    href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "Michael Big"}
      let(:new_email) { "cobra@snake.venom"}

      before do
        fill_in "Name",                  with: new_name
        fill_in "Email",                 with: new_email
        fill_in "Password",              with: user.password
        fill_in "Confirm Password",      with: user.password
        click_button "Save"
      end

      it { should have_selector('title', text: new_name)}
      it { should have_selector('div.alert.alert-success')}
      it { should have_link('Sign out', href: signout_path)}
      specify { user.reload.name.should  == new_name   }
      specify { user.reload.email.should == new_email }
    end

  end

  describe "following/unfollowing" do

    let(:user)       { FactoryGirl.create(:user)}
    let(:other_user) { FactoryGirl.create(:user)}
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3',    text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('title', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end

  end


end
