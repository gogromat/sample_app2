# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe User do

    before do
       @user = User.new(name:                   "Example User",
                        email:                  "user@example.com",
                        password:               "foobar",
                        password_confirmation:  "foobar")
    end

    subject { @user }

    # password_digest => password & password_confirmation
    it { should respond_to(:name)           }
    it { should respond_to(:email)          }
    it { should respond_to(:password_digest)}
    it { should respond_to(:password)       }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_token) }
    it { should respond_to(:admin)          }
    it { should respond_to(:authenticate)   }

    it { should respond_to(:microposts)     }
    #feed - includes current user posts, excludes different user posts
    it { should respond_to(:feed)}

    it { should respond_to(:relationships)  }
    it { should respond_to(:followed_users) }


    it { should     be_valid }
    it { should_not be_admin }

    describe "with admin attribute set to true" do
      before do
        @user.save!
        @user.toggle!(:admin)
      end
      it { should be_admin }
    end

    describe "accessible attributes" do
      it "should not allow access to admin" do
        expect do
          User.new(admin: true)
        end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end

    describe "when name is not present" do
      before { @user.name = ""     }
      it     { should_not be_valid }
    end

    describe "when email is not present" do
      before { @user.email = ""    }
      it     { should_not be_valid }
    end

    describe "when name is too long" do
      before { @user.name = "a" * 51 }
      it     { should_not be_valid   }
    end

    describe "when email format is invalid" do
      it "should be invalid" do

        addresses = %w[user@foo,com
                       user_at_foo.org
                       example.user@foo.foo@baz.com
                       foo@bar+baz.com]
        addresses.each do |invalid_address|
          @user.email     = invalid_address
          @user.save
          @user.should_not  be_valid
        end
      end
    end

    describe "when email address is valid" do
      it "should be valid" do
        addresses = %w[one@email.com
                       one.two@email.biz
                       US-ERs.b@f.b.org
                       first.lst@foo.jp
                       a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          @user.save
          @user.should  be_valid
        end
      end
    end

    describe "when email address is already taken" do
      before do
        user_with_same_email       = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end
      it     { should_not be_valid }
    end

    describe "when password is not present" do
      before { @user.password = @user.password_confirmation = " " }
      it     { should_not be_valid }
    end

    describe "when password doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch"}
      it     { should_not be_valid }
    end

    describe "when password confirmation is nil" do
      before { @user.password_confirmation = nil }
      it     { should_not be_valid }
    end

    describe "return value of authenticate method" do
      # save user in order to test it to authenticate the
      # user that visits web-site again
      before { @user.save }
      # find that user by email (previous email of user :p )
      let(:found_user) { User.find_by_email(@user.email)}

      # our saved user must match the user (found by email) through password
      describe "with valid password" do
        it { should == found_user.authenticate(@user.password)}
      end

      # try to authenticate found user by mismatch password
      describe "with invalid password" do
        # create user with invalid password
        let(:user_for_invalid_password) { found_user.authenticate("InvalidPassword")}
        # "it" is User subject {@user}
        it      { should_not == user_for_invalid_password }
        # specify (same as it) what exactly is different
        specify { user_for_invalid_password.should be_false }
      end

    end

    describe "with a password that's to short" do
      before { @user.password = @user.password_confirmation = "a" * 5}
      it     { should be_invalid}
    end

    describe "email address with mixed case" do
      let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

      it "should be saved all as lower-case" do
        @user.email = mixed_case_email
        @user.save
        @user.reload.email.should == mixed_case_email.downcase
      end
    end

    describe "remember token" do
      before { @user.save }
      its(:remember_token) {should_not be_blank}
      # it {@user.remember_token.should_not be_blank}
    end

    describe "micropost associations" do

      before { @user.save }
      let!(:older_micropost) do
        FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
        end
      let!(:newer_micropost) do
        FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
      end

      it "should have the right microposts in the right order {Twitter style}" do
        @user.microposts.should == [newer_micropost, older_micropost]
      end

      it "should destroy associated microposts" do
        microposts = @user.microposts
        @user.destroy
        microposts.each do |micropost|
          Micropost.find_by_id(micropost.id).should be_nil
        end
        #lambda do
        #  Micropost.find(micropost.id)
        #end.should raise_error(ActiveRecord::RecordNotFound)
      end

      describe "status" do
        let(:unfollowed_post) do
          FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
        end

        its(:feed) { should include(newer_micropost) }
        its(:feed) { should include(older_micropost) }
        its(:feed) { should_not include(unfollowed_post) }
      end

    end

  end
end
