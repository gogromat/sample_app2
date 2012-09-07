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
    it { should respond_to(:name)}
    it { should respond_to(:email)}
    it { should respond_to(:password_digest)}
    it { should respond_to(:password)}
    it { should respond_to(:password_confirmation)}
    it { should respond_to(:authenticate)}

    it { should be_valid }

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


  end
end
