require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the h1 'Sample App'" do
      visit root_path
      page.should have_selector('h1',
                                text: 'Sample App')
    end

    it "Should have the base title" do
      visit root_path
      page.should have_selector('title',
                                text: 'Ruby on Rails Tutorial Sample App')
    end

    it "Should not have a custom page title" do
      visit root_path
      page.should_not have_selector('title',
                                    text: '| Home')
    end
    #    it "should have the title 'Home'" do
    #      visit '/static_pages/home'
    #      page.should have_selector('title',
    #                                text: "Ruby on Rails Tutorial Sample App | Home")
    #    end
  end

  describe "Help page" do

    it "should have the h1 'Help'" do
      visit help_path
      page.should have_selector('h1',
                                text: 'Help')
    end

    it "should have the title 'Help'" do
      visit help_path
      page.should have_selector('title',
                                text: "Ruby on Rails Tutorial Sample App | Help")
    end
  end

  describe "About page" do

    it "should have the h1 'About Us'" do
      visit about_path
      page.should have_selector('h1',
                                text: 'About Us')
    end

    it "should have the title 'About Us'" do
      visit about_path
      page.should have_selector('title',
                                text: "Ruby on Rails Tutorial Sample App | About Us")
    end
  end

  describe "Contact Us page" do

    it "should have the h1 'contact'" do
      visit contact_path
      page.should have_selector('h1',
                                text: "Contact")
    end

    it "should have title 'Contact'" do
      visit contact_path
      page.should have_selector('title',
                                text: "Ruby on Rails Tutorial Sample App | Contact")
    end

  end


end