require 'spec_helper'

describe "Static pages" do

  subject {page}

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading)}
    it { should have_selector('title', text: full_title(page_title))}
  end

  describe "Home page" do
    before {visit root_path}
    let(:heading) {'Sample App'}
    let(:page_title) {''}
    it_should_behave_like "all static pages"
    it { should_not  have_selector 'title', text: '| Home'}
    #it { should      have_selector('h1',    text: 'Sample App')}
    #it { should      have_selector('title', text: full_title(''))}
    #it { should      have_selector 'title', text: 'Ruby on Rails Tutorial Sample App'}

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      #it { should have_link "Sign out" }
      #it { should have_content current_user.name }

      it "should render the user's feed" do
        user.feed.each do |item|
                                    #css id, interpolation
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "it should have following/followers count" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      describe "should show right number of user microposts" do
        # Ruby works, Rails helper.pluralize don't
        let(:posts_count) { user.microposts.count }
        let(:pluralized)  { posts_count.to_s + " micropost".pluralize(posts_count) }
        before do
          FactoryGirl.create(:micropost, user: user, content: "Post 3")
          FactoryGirl.create(:micropost, user: user, content: "Post 4")
          visit root_path
        end

        specify {page.should have_content("#{pluralized}") }
      end

      describe "should have right pagination" do

        before(:all) { 30.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")}}
         after(:all) { user.microposts.delete_all }

        it { should have_selector('div.pagination')}

        it 'should list each micropost by user' do
          #User.all.each do |user|
          user.microposts.paginate(page: 1).each do |micropost|
            page.should have_selector('li', text: micropost.content)
          end
        end

      end

    end

    describe "for not signed in users" do
      it { should have_link "Sign in"}
      it { should have_link "Sign up now!"}
    end

  end

  describe "Help page" do
    before {visit help_path}
    let(:heading)    {'Help'}
    let(:page_title) {'Help'}
    it_should_behave_like "all static pages"
    #it { should     have_selector('h1',     text: 'Help')}
    #it { should     have_selector('title',  text: full_title('Help'))}
  end

  describe "About page" do
    before {visit about_path}
    let(:heading)    {'About Us'}
    let(:page_title) {'About Us'}
    it_should_behave_like "all static pages"
    #it { should     have_selector('h1',     text: 'About Us')}
    #it { should     have_selector('title',  text: full_title('About Us'))}
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    {'Contact'}
    let(:page_title) {'Contact'}
    it_should_behave_like "all static pages"
    #it { should     have_selector('h1',     text: "Contact")}
    #it { should     have_selector('title',  text: full_title('Contact'))}
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "sample app"
    page.should have_selector 'title', text: full_title('')
  end



end